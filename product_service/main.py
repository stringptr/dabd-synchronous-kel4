import os
import uuid
import json
import hashlib
import logging
from datetime import datetime, timedelta, timezone
from typing import Optional, List

from fastapi import FastAPI, Depends, HTTPException, status, Request, Response, Header
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
from sqlalchemy import (
    create_engine, Column, Integer, String, Float, DateTime, ForeignKey,
    text, Numeric, Table, CheckConstraint, ForeignKeyConstraint, UniqueConstraint, func
)
from sqlalchemy.orm import sessionmaker, declarative_base, Session, relationship
from sqlalchemy.exc import IntegrityError

# Logging setup
logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger("product_service")

# Database setup
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "postgres")
DB_NAME = os.getenv("DB_NAME", "postgres")
DB_PORT = os.getenv("DB_PORT", "5432")
SQLALCHEMY_DATABASE_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

DEFAULT_RESERVATION_TIMEOUT_MINUTES = int(os.getenv("RESERVATION_EXPIRATION_MINUTES", "15"))

categories = Table("categories", Base.metadata, Column("category_id", Integer, primary_key=True))
suppliers = Table("suppliers", Base.metadata, Column("supplier_id", Integer, primary_key=True))
warehouses = Table("warehouses", Base.metadata, Column("warehouse_id", Integer, primary_key=True))

class Product(Base):
    __tablename__ = "products"
    product_id = Column(Integer, primary_key=True)
    name = Column(String(200), nullable=False)
    description = Column(String)
    price = Column(Numeric(10, 2), nullable=False)
    cost = Column(Numeric(10, 2))
    category_id = Column(Integer, ForeignKey("categories.category_id"))
    supplier_id = Column(Integer, ForeignKey("suppliers.supplier_id"))
    created_at = Column(DateTime, server_default=text("CURRENT_TIMESTAMP"))
    
    inventory = relationship("Inventory", back_populates="product")

class Inventory(Base):
    __tablename__ = "inventory"
    product_id = Column(Integer, ForeignKey("products.product_id", ondelete="CASCADE"), primary_key=True)
    warehouse_id = Column(Integer, ForeignKey("warehouses.warehouse_id", ondelete="CASCADE"), primary_key=True)
    quantity_on_hand = Column(Integer, nullable=False, default=0)
    reserved_quantity = Column(Integer, nullable=False, default=0)
    reorder_level = Column(Integer, server_default=text("10"))
    
    __table_args__ = (
        CheckConstraint("reserved_quantity >= 0", name="chk_inventory_reserved_non_negative"),
        CheckConstraint("reserved_quantity <= quantity_on_hand", name="chk_inventory_reserved_le_on_hand"),
        CheckConstraint("quantity_on_hand >= 0", name="chk_inventory_quantity_on_hand_non_negative"),
    )

    product = relationship("Product", back_populates="inventory")
    reservation_items = relationship("StockReservationItem", back_populates="inventory")

class StockReservation(Base):
    __tablename__ = "stock_reservations"
    reservation_id = Column(Integer, primary_key=True, autoincrement=True)
    operation_id = Column(String(100), unique=True, nullable=False)
    request_fingerprint = Column(String(64), nullable=False)
    status = Column(String(20), nullable=False) # PENDING, ACTIVE, CONFIRMED, RELEASED, EXPIRED, FAILED
    failure_code = Column(String(50), nullable=True)
    failure_reason = Column(String(255), nullable=True)
    expires_at = Column(DateTime(timezone=True), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=text("clock_timestamp()"), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=text("clock_timestamp()"), onupdate=func.clock_timestamp(), nullable=False)

    __table_args__ = (
        CheckConstraint("status IN ('PENDING', 'ACTIVE', 'CONFIRMED', 'RELEASED', 'EXPIRED', 'FAILED')", name="chk_stock_reservations_status"),
    )

    items = relationship("StockReservationItem", back_populates="reservation", cascade="all, delete-orphan")

class StockReservationItem(Base):
    __tablename__ = "stock_reservation_items"
    reservation_item_id = Column(Integer, primary_key=True, autoincrement=True)
    reservation_id = Column(Integer, ForeignKey("stock_reservations.reservation_id", ondelete="CASCADE"), nullable=False)
    product_id = Column(Integer, nullable=False)
    warehouse_id = Column(Integer, nullable=False)
    quantity = Column(Integer, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=text("clock_timestamp()"), nullable=False)

    __table_args__ = (
        ForeignKeyConstraint(
            ["product_id", "warehouse_id"],
            ["inventory.product_id", "inventory.warehouse_id"],
            ondelete="RESTRICT",
            name="fk_reservation_items_inventory"
        ),
        CheckConstraint("quantity > 0", name="chk_reservation_item_quantity_positive"),
    )

    reservation = relationship("StockReservation", back_populates="items")
    inventory = relationship("Inventory", back_populates="reservation_items")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# App setup
app = FastAPI(title="Product Service")

@app.middleware("http")
async def add_request_id_and_log(request: Request, call_next):
    request_id = request.headers.get("X-Request-ID") or str(uuid.uuid4())
    start_time = datetime.utcnow()
    
    response = await call_next(request)
    
    duration = (datetime.utcnow() - start_time).total_seconds()
    logger.info(
        '{"service": "product-service", "request_id": "%s", "method": "%s", "path": "%s", "status": %d, "duration": %f}',
        request_id, request.method, request.url.path, response.status_code, duration
    )
    response.headers["X-Request-ID"] = request_id
    response.headers["X-Service-Instance"] = os.getenv("INSTANCE_NAME", "product-service")
    return response

# Schemas
class ProductCreate(BaseModel):
    name: str = Field(..., max_length=200)
    description: Optional[str] = None
    price: float = Field(..., ge=0)
    cost: Optional[float] = Field(None, ge=0)
    category_id: Optional[int] = None
    supplier_id: Optional[int] = None

class ProductResponse(BaseModel):
    product_id: int
    name: str
    description: Optional[str] = None
    price: float
    category_id: Optional[int] = None
    supplier_id: Optional[int] = None
    total_stock: int

# Stage 2B Reservation Schemas
class ReservationItemIn(BaseModel):
    product_id: int
    quantity: int = Field(..., gt=0)

class ReservationCreateRequest(BaseModel):
    operation_id: str = Field(..., min_length=1, max_length=100)
    items: List[ReservationItemIn] = Field(..., min_length=1)

class ReservationItemOut(BaseModel):
    reservation_item_id: int
    product_id: int
    warehouse_id: int
    quantity: int

class ReservationResponse(BaseModel):
    reservation_id: int
    operation_id: str
    status: str
    failure_code: Optional[str] = None
    failure_reason: Optional[str] = None
    expires_at: datetime
    created_at: datetime
    updated_at: datetime
    items: List[ReservationItemOut] = []

# Failure Code Constants
FAILURE_CODE_PRODUCT_NOT_FOUND = "PRODUCT_NOT_FOUND"
FAILURE_CODE_INSUFFICIENT_STOCK = "INSUFFICIENT_STOCK"
FAILURE_CODE_CONFLICTING_PAYLOAD = "CONFLICTING_PAYLOAD"
FAILURE_CODE_DUPLICATE_PRODUCT = "DUPLICATE_PRODUCT_IN_REQUEST"
FAILURE_CODE_ALREADY_CONFIRMED = "ALREADY_CONFIRMED"
FAILURE_CODE_ALREADY_RELEASED = "ALREADY_RELEASED"
FAILURE_CODE_RESERVATION_EXPIRED = "RESERVATION_EXPIRED"
FAILURE_CODE_DATA_INTEGRITY = "DATA_INTEGRITY_VIOLATION"

class ReservationException(HTTPException):
    def __init__(self, status_code: int, failure_code: str, failure_reason: str):
        super().__init__(status_code=status_code, detail=failure_reason)
        self.failure_code = failure_code
        self.failure_reason = failure_reason

@app.exception_handler(ReservationException)
async def reservation_exception_handler(request: Request, exc: ReservationException):
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "detail": exc.failure_reason,
            "failure_code": exc.failure_code,
            "failure_reason": exc.failure_reason
        }
    )

# -----------------------------------------------------------------------------
# ARCHITECTURAL NOTICE: DEFERRED EXPIRATION (STAGE 2B LIMITATION)
# -----------------------------------------------------------------------------
# Stage 2B does NOT run an autonomous background worker to sweep expired
# reservations. This is an intentional architectural decision to prevent race
# conditions with in-flight payments.
# 
# Expiration lifecycle rules in Stage 2B:
# 1. An expired ACTIVE reservation remains ACTIVE in storage until an explicit
#    confirmation or release request is processed.
# 2. When confirm_reservation() or release_reservation() is invoked, the database
#    authoritative wall-clock time (clock_timestamp()) is evaluated after
#    exclusive row locks are acquired. If now >= expires_at, the reservation
#    atomically transitions to EXPIRED and all held inventory is released.
# 3. Stage 2C checkout orchestration must NOT assume expired ACTIVE reservations
#    are automatically swept or released in the background.
# 4. Stage 2D payment orchestration will introduce the coordinated payment-aware
#    expiration, recovery, and reconciliation worker.
# -----------------------------------------------------------------------------

# Internal security
INTERNAL_API_KEY = os.getenv("INTERNAL_API_KEY")
if not INTERNAL_API_KEY:
    raise ValueError("INTERNAL_API_KEY environment variable is missing!")

def require_internal(x_internal_secret: str = Header(...)):
    if x_internal_secret != INTERNAL_API_KEY:
        raise HTTPException(status_code=403, detail="Forbidden: Invalid internal secret")
    return True

@app.get("/internal/ping", dependencies=[Depends(require_internal)])
def internal_ping():
    return {"status": "internal_ok"}

def require_admin(x_user_role: Optional[str] = Header(None)):
    if x_user_role != "admin":
        raise HTTPException(status_code=403, detail="Forbidden: Admin access required")
    return True

def to_utc(dt: datetime) -> datetime:
    if dt.tzinfo is None:
        return dt.replace(tzinfo=timezone.utc)
    return dt.astimezone(timezone.utc)

def get_db_clock_time(db: Session) -> datetime:
    ts = db.execute(text("SELECT clock_timestamp()")).scalar()
    if not isinstance(ts, datetime):
        ts = datetime.now(timezone.utc)
    return to_utc(ts)

def compute_request_fingerprint(items: List[ReservationItemIn]) -> str:
    # Sort by product_id ascending to generate canonical JSON
    sorted_items = sorted(items, key=lambda x: x.product_id)
    canonical = [{"product_id": x.product_id, "quantity": x.quantity} for x in sorted_items]
    canonical_str = json.dumps(canonical, separators=(",", ":"))
    return hashlib.sha256(canonical_str.encode("utf-8")).hexdigest()

def get_available_stock(inv: Inventory) -> int:
    avail = inv.quantity_on_hand - getattr(inv, "reserved_quantity", 0)
    if avail < 0 or getattr(inv, "reserved_quantity", 0) < 0 or inv.quantity_on_hand < 0:
        raise HTTPException(
            status_code=500,
            detail=f"Data integrity violation: invalid stock state on product {inv.product_id}, warehouse {inv.warehouse_id}"
        )
    return avail

def build_reservation_response(res: StockReservation) -> ReservationResponse:
    items_out = [
        ReservationItemOut(
            reservation_item_id=item.reservation_item_id,
            product_id=item.product_id,
            warehouse_id=item.warehouse_id,
            quantity=item.quantity
        )
        for item in (res.items or [])
    ]
    return ReservationResponse(
        reservation_id=res.reservation_id,
        operation_id=res.operation_id,
        status=res.status,
        failure_code=res.failure_code,
        failure_reason=res.failure_reason,
        expires_at=res.expires_at,
        created_at=res.created_at,
        updated_at=res.updated_at,
        items=items_out
    )

# Public Routes
@app.get("/products", response_model=List[ProductResponse])
def get_products(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    products = db.query(Product).offset(skip).limit(limit).all()
    res = []
    for p in products:
        total_stock = sum(get_available_stock(inv) for inv in p.inventory) if p.inventory else 0
        res.append({
            "product_id": p.product_id,
            "name": p.name,
            "description": p.description,
            "price": float(p.price),
            "category_id": p.category_id,
            "supplier_id": p.supplier_id,
            "total_stock": total_stock
        })
    return res

@app.get("/products/{product_id}", response_model=ProductResponse)
def get_product(product_id: int, db: Session = Depends(get_db)):
    p = db.query(Product).filter(Product.product_id == product_id).first()
    if not p:
        raise HTTPException(status_code=404, detail="Product not found")
    total_stock = sum(get_available_stock(inv) for inv in p.inventory) if p.inventory else 0
    return {
        "product_id": p.product_id,
        "name": p.name,
        "description": p.description,
        "price": float(p.price),
        "category_id": p.category_id,
        "supplier_id": p.supplier_id,
        "total_stock": total_stock
    }

@app.post("/products", response_model=ProductResponse)
def create_product(
    product: ProductCreate, 
    db: Session = Depends(get_db), 
    _=Depends(require_admin)
):
    new_product = Product(
        name=product.name,
        description=product.description,
        price=product.price,
        category_id=product.category_id,
        supplier_id=product.supplier_id
    )
    db.add(new_product)
    db.commit()
    db.refresh(new_product)
    return {
        "product_id": new_product.product_id,
        "name": new_product.name,
        "description": new_product.description,
        "price": float(new_product.price),
        "category_id": new_product.category_id,
        "supplier_id": new_product.supplier_id,
        "total_stock": 0
    }

# Internal Reservation Endpoints
@app.post("/internal/reservations", response_model=ReservationResponse, status_code=201, dependencies=[Depends(require_internal)])
def create_reservation(req: ReservationCreateRequest, response: Response, db: Session = Depends(get_db)):
    # 1. Reject duplicate product_ids in a single request
    pids = [item.product_id for item in req.items]
    if len(pids) != len(set(pids)):
        raise ReservationException(
            status_code=422,
            failure_code=FAILURE_CODE_DUPLICATE_PRODUCT,
            failure_reason="Duplicate product_id in reservation request is not allowed"
        )

    fingerprint = compute_request_fingerprint(req.items)

    # 2. Check if operation_id already exists (fast-path for sequential replay)
    existing = db.query(StockReservation).filter(StockReservation.operation_id == req.operation_id).first()
    if existing:
        if existing.request_fingerprint != fingerprint:
            raise ReservationException(
                status_code=409,
                failure_code=FAILURE_CODE_CONFLICTING_PAYLOAD,
                failure_reason="Operation ID reused with conflicting payload"
            )
        if existing.status == "FAILED":
            status_code = 404 if existing.failure_code == FAILURE_CODE_PRODUCT_NOT_FOUND else 409
            raise ReservationException(
                status_code=status_code,
                failure_code=existing.failure_code or "FAILED",
                failure_reason=existing.failure_reason or "Reservation previously failed"
            )
        response.status_code = status.HTTP_200_OK
        return build_reservation_response(existing)

    # 3. Concurrency-safe operation serialization:
    # Insert preliminary placeholder row with status='PENDING' and immediately flush to serialize on UNIQUE(operation_id)
    now_ts = get_db_clock_time(db)
    placeholder = StockReservation(
        operation_id=req.operation_id,
        request_fingerprint=fingerprint,
        status="PENDING",
        expires_at=now_ts,
        created_at=now_ts,
        updated_at=now_ts
    )
    db.add(placeholder)
    try:
        db.flush()
    except IntegrityError:
        # A concurrent request won the race to insert this operation_id
        db.rollback()
        existing = db.query(StockReservation).filter(StockReservation.operation_id == req.operation_id).first()
        if not existing:
            raise HTTPException(status_code=409, detail="Concurrent reservation conflict; please retry")
        if existing.request_fingerprint != fingerprint:
            raise ReservationException(
                status_code=409,
                failure_code=FAILURE_CODE_CONFLICTING_PAYLOAD,
                failure_reason="Operation ID reused with conflicting payload"
            )
        if existing.status == "FAILED":
            status_code = 404 if existing.failure_code == FAILURE_CODE_PRODUCT_NOT_FOUND else 409
            raise ReservationException(
                status_code=status_code,
                failure_code=existing.failure_code or "FAILED",
                failure_reason=existing.failure_reason or "Reservation previously failed"
            )
        response.status_code = status.HTTP_200_OK
        return build_reservation_response(existing)

    # We own the operation_id lock.
    sorted_pids = sorted(pids)

    # 4. Verify all requested products exist (Definitive business failure check)
    existing_pids = set(p[0] for p in db.query(Product.product_id).filter(Product.product_id.in_(sorted_pids)).all())
    missing_pids = set(sorted_pids) - existing_pids
    if missing_pids:
        placeholder.status = "FAILED"
        placeholder.failure_code = FAILURE_CODE_PRODUCT_NOT_FOUND
        placeholder.failure_reason = f"Products not found: {sorted(list(missing_pids))}"
        placeholder.updated_at = get_db_clock_time(db)
        db.commit()
        raise ReservationException(
            status_code=404,
            failure_code=FAILURE_CODE_PRODUCT_NOT_FOUND,
            failure_reason=placeholder.failure_reason
        )

    # 5. Acquire row-level locks on inventory in global deterministic order
    inv_rows = db.query(Inventory).filter(
        Inventory.product_id.in_(sorted_pids)
    ).order_by(Inventory.product_id.asc(), Inventory.warehouse_id.asc()).with_for_update().all()

    inv_by_product = {}
    for inv in inv_rows:
        inv_by_product.setdefault(inv.product_id, []).append(inv)

    # 6. Check stock availability across warehouses (Definitive business failure check)
    allocations = []
    for item in req.items:
        product_inv = inv_by_product.get(item.product_id, [])
        total_avail = sum(get_available_stock(inv) for inv in product_inv)
        if total_avail < item.quantity:
            # Persist definitive business failure
            placeholder.status = "FAILED"
            placeholder.failure_code = FAILURE_CODE_INSUFFICIENT_STOCK
            placeholder.failure_reason = f"Insufficient stock for product {item.product_id}: requested {item.quantity}, available {total_avail}"
            placeholder.updated_at = get_db_clock_time(db)
            db.commit()
            raise ReservationException(
                status_code=409,
                failure_code=FAILURE_CODE_INSUFFICIENT_STOCK,
                failure_reason=placeholder.failure_reason
            )

        needed = item.quantity
        for inv in product_inv:
            avail = get_available_stock(inv)
            if avail > 0:
                alloc = min(needed, avail)
                allocations.append((inv, alloc))
                needed -= alloc
                if needed == 0:
                    break

    # 7. Apply reservation increments
    activation_time = get_db_clock_time(db)
    expires_at = activation_time + timedelta(minutes=DEFAULT_RESERVATION_TIMEOUT_MINUTES)

    placeholder.status = "ACTIVE"
    placeholder.expires_at = expires_at
    placeholder.updated_at = activation_time

    for inv, alloc in allocations:
        inv.reserved_quantity += alloc
        res_item = StockReservationItem(
            reservation_id=placeholder.reservation_id,
            product_id=inv.product_id,
            warehouse_id=inv.warehouse_id,
            quantity=alloc,
            created_at=activation_time
        )
        db.add(res_item)

    try:
        db.commit()
    except IntegrityError as e:
        db.rollback()
        existing = db.query(StockReservation).filter(StockReservation.operation_id == req.operation_id).first()
        if existing:
            if existing.request_fingerprint != fingerprint:
                raise ReservationException(
                    status_code=409,
                    failure_code=FAILURE_CODE_CONFLICTING_PAYLOAD,
                    failure_reason="Operation ID reused with conflicting payload"
                )
            if existing.status == "FAILED":
                status_code = 404 if existing.failure_code == FAILURE_CODE_PRODUCT_NOT_FOUND else 409
                raise ReservationException(
                    status_code=status_code,
                    failure_code=existing.failure_code or "FAILED",
                    failure_reason=existing.failure_reason or "Reservation previously failed"
                )
            response.status_code = status.HTTP_200_OK
            return build_reservation_response(existing)
        raise HTTPException(status_code=409, detail=f"Concurrent reservation conflict: {str(e)}")

    db.refresh(placeholder)
    response.status_code = status.HTTP_201_CREATED
    return build_reservation_response(placeholder)

@app.get("/internal/reservations/{operation_id}", response_model=ReservationResponse, dependencies=[Depends(require_internal)])
def get_reservation(operation_id: str, db: Session = Depends(get_db)):
    res = db.query(StockReservation).filter(StockReservation.operation_id == operation_id).first()
    if not res:
        raise HTTPException(status_code=404, detail="Reservation not found")
    return build_reservation_response(res)

@app.post("/internal/reservations/{operation_id}/confirm", response_model=ReservationResponse, dependencies=[Depends(require_internal)])
def confirm_reservation(operation_id: str, db: Session = Depends(get_db)):
    res = db.query(StockReservation).filter(StockReservation.operation_id == operation_id).with_for_update().first()
    if not res:
        raise HTTPException(status_code=404, detail="Reservation not found")

    if res.status == "CONFIRMED":
        return build_reservation_response(res) # Idempotent repeat

    if res.status == "RELEASED":
        raise ReservationException(
            status_code=409,
            failure_code=FAILURE_CODE_ALREADY_RELEASED,
            failure_reason="Cannot confirm reservation: already released"
        )

    if res.status == "EXPIRED":
        raise ReservationException(
            status_code=409,
            failure_code=FAILURE_CODE_RESERVATION_EXPIRED,
            failure_reason="Cannot confirm reservation: already expired"
        )

    if res.status == "FAILED":
        status_code = 404 if res.failure_code == FAILURE_CODE_PRODUCT_NOT_FOUND else 409
        raise ReservationException(
            status_code=status_code,
            failure_code=res.failure_code or "FAILED",
            failure_reason=f"Cannot confirm reservation: {res.failure_reason or 'failed'}"
        )

    sorted_keys = sorted([(item.product_id, item.warehouse_id, item.quantity) for item in res.items], key=lambda x: (x[0], x[1]))
    inv_map = {}
    for pid, wid, qty in sorted_keys:
        inv = db.query(Inventory).filter(Inventory.product_id == pid, Inventory.warehouse_id == wid).with_for_update().first()
        if not inv:
            db.rollback()
            raise ReservationException(
                status_code=500,
                failure_code=FAILURE_CODE_DATA_INTEGRITY,
                failure_reason=f"Data integrity violation: inventory record missing for product {pid}, warehouse {wid}"
            )
        inv_map[(pid, wid)] = inv

    # Authoritative database wall-clock time AFTER acquiring all necessary locks
    now_ts = get_db_clock_time(db)

    # Check expiration boundary using authoritative clock
    if now_ts >= to_utc(res.expires_at):
        # Finalize expiration and release hold atomically
        for pid, wid, qty in sorted_keys:
            inv = inv_map[(pid, wid)]
            inv.reserved_quantity -= qty
            if inv.reserved_quantity < 0:
                db.rollback()
                raise ReservationException(
                    status_code=500,
                    failure_code=FAILURE_CODE_DATA_INTEGRITY,
                    failure_reason="Data integrity violation: reserved_quantity became negative"
                )
        res.status = "EXPIRED"
        res.updated_at = now_ts
        db.commit()
        raise ReservationException(
            status_code=409,
            failure_code=FAILURE_CODE_RESERVATION_EXPIRED,
            failure_reason="Reservation has expired"
        )

    # Valid confirmation: permanently deduct both quantity_on_hand and reserved_quantity
    for pid, wid, qty in sorted_keys:
        inv = inv_map[(pid, wid)]
        inv.quantity_on_hand -= qty
        inv.reserved_quantity -= qty
        if inv.quantity_on_hand < 0 or inv.reserved_quantity < 0:
            db.rollback()
            raise ReservationException(
                status_code=500,
                failure_code=FAILURE_CODE_DATA_INTEGRITY,
                failure_reason="Data integrity violation: negative inventory during confirmation"
            )

    res.status = "CONFIRMED"
    res.updated_at = now_ts
    db.commit()
    db.refresh(res)
    return build_reservation_response(res)

@app.post("/internal/reservations/{operation_id}/release", response_model=ReservationResponse, dependencies=[Depends(require_internal)])
def release_reservation(operation_id: str, db: Session = Depends(get_db)):
    res = db.query(StockReservation).filter(StockReservation.operation_id == operation_id).with_for_update().first()
    if not res:
        raise HTTPException(status_code=404, detail="Reservation not found")

    if res.status == "RELEASED":
        return build_reservation_response(res) # Idempotent repeat

    if res.status == "CONFIRMED":
        raise ReservationException(
            status_code=409,
            failure_code=FAILURE_CODE_ALREADY_CONFIRMED,
            failure_reason="Cannot release reservation: already confirmed"
        )

    if res.status == "EXPIRED":
        raise ReservationException(
            status_code=409,
            failure_code=FAILURE_CODE_RESERVATION_EXPIRED,
            failure_reason="Cannot release reservation: already expired"
        )

    if res.status == "FAILED":
        status_code = 404 if res.failure_code == FAILURE_CODE_PRODUCT_NOT_FOUND else 409
        raise ReservationException(
            status_code=status_code,
            failure_code=res.failure_code or "FAILED",
            failure_reason=f"Cannot release reservation: {res.failure_reason or 'failed'}"
        )

    sorted_keys = sorted([(item.product_id, item.warehouse_id, item.quantity) for item in res.items], key=lambda x: (x[0], x[1]))
    inv_map = {}
    for pid, wid, qty in sorted_keys:
        inv = db.query(Inventory).filter(Inventory.product_id == pid, Inventory.warehouse_id == wid).with_for_update().first()
        if not inv:
            db.rollback()
            raise ReservationException(
                status_code=500,
                failure_code=FAILURE_CODE_DATA_INTEGRITY,
                failure_reason=f"Data integrity violation: inventory record missing for product {pid}, warehouse {wid}"
            )
        inv_map[(pid, wid)] = inv

    now_ts = get_db_clock_time(db)

    # Release hold if ACTIVE
    if res.status == "ACTIVE":
        for pid, wid, qty in sorted_keys:
            inv = inv_map[(pid, wid)]
            inv.reserved_quantity -= qty
            if inv.reserved_quantity < 0:
                db.rollback()
                raise ReservationException(
                    status_code=500,
                    failure_code=FAILURE_CODE_DATA_INTEGRITY,
                    failure_reason="Data integrity violation: reserved_quantity became negative"
                )

    res.status = "RELEASED"
    res.updated_at = now_ts
    db.commit()
    db.refresh(res)
    return build_reservation_response(res)

@app.get("/health/live")
def health_live():
    return {"status": "alive"}

@app.get("/health/ready")
def health_ready(db: Session = Depends(get_db)):
    try:
        db.execute(text("SELECT 1"))
        return {"status": "ready"}
    except Exception:
        raise HTTPException(status_code=503, detail="Database not ready")
