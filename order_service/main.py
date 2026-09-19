import os
import uuid
import time
import logging
import hashlib
import json
from datetime import datetime, timezone
from decimal import Decimal, ROUND_HALF_UP
from typing import Optional, List, Tuple

from fastapi import FastAPI, Depends, HTTPException, status, Request, Response, Header
from pydantic import BaseModel, Field
from sqlalchemy import (
    create_engine, Column, Integer, String, DateTime, ForeignKey, 
    text, Numeric, Table, UniqueConstraint, CheckConstraint, JSON
)
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import sessionmaker, declarative_base, Session, relationship
from sqlalchemy.exc import IntegrityError
import httpx
import pybreaker

# Logging setup
logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger("order_service")

# Database setup
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "postgres")
DB_NAME = os.getenv("DB_NAME", "postgres")
DB_PORT = os.getenv("DB_PORT", "5432")

SQLALCHEMY_DATABASE_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

users = Table("users", Base.metadata, Column("user_id", Integer, primary_key=True))
coupons = Table("coupons", Base.metadata, Column("coupon_id", Integer, primary_key=True))
products = Table("products", Base.metadata, Column("product_id", Integer, primary_key=True))

class Order(Base):
    __tablename__ = "orders"
    order_id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.user_id"), nullable=False)
    coupon_id = Column(Integer, ForeignKey("coupons.coupon_id"), nullable=True)
    order_date = Column(DateTime, default=datetime.utcnow)
    status = Column(String(20), nullable=False, default="Pending")
    total_amount = Column(Numeric(10, 2), nullable=False)
    
    items = relationship("OrderItem", back_populates="order", cascade="all, delete-orphan")

class OrderItem(Base):
    __tablename__ = "order_items"
    order_item_id = Column(Integer, primary_key=True)
    order_id = Column(Integer, ForeignKey("orders.order_id", ondelete="CASCADE"), nullable=False)
    product_id = Column(Integer, ForeignKey("products.product_id"), nullable=False)
    quantity = Column(Integer, nullable=False)
    unit_price = Column(Numeric(10, 2), nullable=False)
    discount = Column(Numeric(5, 2), default=0.00)
    
    order = relationship("Order", back_populates="items")

class Cart(Base):
    __tablename__ = "carts"
    cart_id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.user_id", ondelete="CASCADE"), nullable=False, unique=True)
    created_at = Column(DateTime, server_default=text("CURRENT_TIMESTAMP"))
    updated_at = Column(DateTime, server_default=text("CURRENT_TIMESTAMP"), onupdate=datetime.utcnow)

    items = relationship("CartItemModel", back_populates="cart", cascade="all, delete-orphan")

class CartItemModel(Base):
    __tablename__ = "cart_items"
    cart_item_id = Column(Integer, primary_key=True)
    cart_id = Column(Integer, ForeignKey("carts.cart_id", ondelete="CASCADE"), nullable=False)
    product_id = Column(Integer, ForeignKey("products.product_id", ondelete="CASCADE"), nullable=False)
    quantity = Column(Integer, nullable=False)
    created_at = Column(DateTime, server_default=text("CURRENT_TIMESTAMP"))

    __table_args__ = (
        UniqueConstraint("cart_id", "product_id", name="uq_cart_product"),
        CheckConstraint("quantity > 0", name="chk_cart_item_quantity_positive"),
    )

    cart = relationship("Cart", back_populates="items")

class Checkout(Base):
    __tablename__ = "checkouts"
    checkout_id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.user_id", ondelete="RESTRICT"), nullable=False)
    operation_id = Column(String(64), unique=True, nullable=False)
    idempotency_key = Column(String(128), nullable=False)
    request_fingerprint = Column(String(64), nullable=False)
    reservation_op_id = Column(String(64), unique=True, nullable=False)
    status = Column(String(32), nullable=False)
    order_id = Column(Integer, ForeignKey("orders.order_id", ondelete="SET NULL"), unique=True, nullable=True)
    total_amount = Column(Numeric(10, 2), nullable=False)
    items_snapshot = Column(JSON().with_variant(JSONB, "postgresql"), nullable=False)
    failure_code = Column(String(64), nullable=True)
    failure_reason = Column(String, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=text("CURRENT_TIMESTAMP"), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=text("CURRENT_TIMESTAMP"), nullable=False)

    __table_args__ = (
        UniqueConstraint("user_id", "idempotency_key", name="uq_checkouts_user_idempotency"),
        CheckConstraint("total_amount >= 0", name="chk_checkouts_total_positive"),
        CheckConstraint(
            "status IN ('INITIATED', 'RESERVING', 'RESERVED', 'UNKNOWN', 'FAILED', 'COMPENSATION_REQUIRED', 'CANCELLED')",
            name="chk_checkouts_status"
        ),
    )

    order = relationship("Order")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Product Service setup & internal replica discovery
PRODUCT_SERVICE_URL = os.getenv("PRODUCT_SERVICE_URL", "http://nginx/api/products")
INTERNAL_API_KEY = os.getenv("INTERNAL_API_KEY")
if not INTERNAL_API_KEY:
    raise ValueError("INTERNAL_API_KEY environment variable is missing!")

breaker = pybreaker.CircuitBreaker(fail_max=3, reset_timeout=15)

def get_product_service_replicas() -> List[str]:
    env_replicas = os.getenv("PRODUCT_SERVICE_REPLICAS")
    if env_replicas:
        return [r.strip() for r in env_replicas.split(",") if r.strip()]
    return ["http://product-service-1:8000", "http://product-service-2:8000"]

def fetch_product(product_id: int, request_id: str, authorization: str = None):
    headers = {
        "X-Request-ID": request_id,
        "X-Internal-Secret": INTERNAL_API_KEY
    }
    if authorization:
        headers["Authorization"] = authorization

    urls = [f"{PRODUCT_SERVICE_URL}/{product_id}"]
    for r in get_product_service_replicas():
        urls.append(f"{r}/products/{product_id}")

    last_error = None
    for url in urls:
        try:
            with httpx.Client(timeout=httpx.Timeout(3.0, connect=1.5)) as client:
                resp = client.get(url, headers=headers)
            if resp.status_code == 200:
                return resp.json()
            elif resp.status_code == 404:
                raise HTTPException(status_code=404, detail=f"Product {product_id} not found")
            elif resp.status_code in (502, 503, 504):
                last_error = resp.status_code
                continue
        except HTTPException:
            raise
        except Exception as e:
            last_error = e
            continue

    raise Exception(f"Failed to communicate with Product Service: {last_error}")

@breaker
def fetch_product_with_breaker(product_id: int, request_id: str, authorization: str = None):
    return fetch_product(product_id, request_id, authorization)

DOCUMENTED_BUSINESS_FAILURE_CODES = {
    "PRODUCT_NOT_FOUND",
    "INSUFFICIENT_STOCK",
    "CONFLICTING_PAYLOAD",
    "DUPLICATE_PRODUCT_IN_REQUEST",
    "ALREADY_CONFIRMED",
    "ALREADY_RELEASED",
    "RESERVATION_EXPIRED",
    "DATA_INTEGRITY_VIOLATION",
    "CONFLICT"
}

def reserve_inventory_internal(
    reservation_op_id: str, 
    items: List[dict]
) -> Tuple[str, Optional[dict], Optional[str], Optional[str], bool]:
    """
    Calls Product Service internal reservation endpoint across replicas.
    Returns: (status, response_data, failure_code, failure_reason, is_ambiguous).

    Distinguishes:
    - Valid successful reservation responses (201, 200 ACTIVE).
    - Documented, structured, definitive business failures (404 PRODUCT_NOT_FOUND, 409 INSUFFICIENT_STOCK/CONFLICT, etc.).
    - Ambiguous infrastructure failures (500, 504, timeouts, connection errors, malformed responses) -> returns UNKNOWN (is_ambiguous=True).
    """
    replicas = get_product_service_replicas()
    headers = {
        "X-Internal-Secret": INTERNAL_API_KEY,
        "Content-Type": "application/json"
    }
    payload = {
        "operation_id": reservation_op_id,
        "items": [{"product_id": it["product_id"], "quantity": it["quantity"]} for it in items]
    }
    
    last_error = None
    last_status = None
    for replica in replicas:
        try:
            with httpx.Client(timeout=httpx.Timeout(5.0, connect=3.0)) as client:
                resp = client.post(f"{replica}/internal/reservations", json=payload, headers=headers)
            
            # Category 1: Valid successful reservation responses
            if resp.status_code == 201:
                try:
                    data = resp.json()
                    if isinstance(data, dict) and data.get("operation_id") and data.get("status") == "ACTIVE":
                        return ("ACTIVE", data, None, None, False)
                    return ("UNKNOWN", data if isinstance(data, dict) else None, "MALFORMED_RESPONSE", "Malformed 201 response schema", True)
                except Exception as e:
                    return ("UNKNOWN", None, "MALFORMED_RESPONSE", f"Failed to parse 201 response: {e}", True)

            elif resp.status_code == 200:
                try:
                    data = resp.json()
                    if isinstance(data, dict):
                        st = data.get("status", "ACTIVE")
                        if st == "ACTIVE":
                            return ("ACTIVE", data, None, None, False)
                        elif st == "FAILED":
                            fc = data.get("failure_code", "FAILED")
                            fr = data.get("failure_reason") or str(data.get("detail"))
                            return ("FAILED", data, fc, fr, False)
                        elif st in ("CONFIRMED", "RELEASED", "EXPIRED"):
                            return (st, data, data.get("failure_code"), data.get("failure_reason"), False)
                    return ("UNKNOWN", data if isinstance(data, dict) else None, "MALFORMED_RESPONSE", "Malformed 200 response schema", True)
                except Exception as e:
                    return ("UNKNOWN", None, "MALFORMED_RESPONSE", f"Failed to parse 200 response: {e}", True)

            # Category 2: Documented, structured, definitive business failures
            elif resp.status_code in (400, 404, 409):
                try:
                    data = resp.json()
                    if isinstance(data, dict):
                        fc = data.get("failure_code")
                        fr = data.get("failure_reason") or str(data.get("detail"))
                        if fc in DOCUMENTED_BUSINESS_FAILURE_CODES:
                            return ("FAILED", data, fc, fr, False)
                except Exception:
                    pass

                last_error = f"Replica {replica} returned undocumented HTTP {resp.status_code}: {resp.text}"
                last_status = resp.status_code
                continue

            # Category 3: Ambiguous infrastructure failures and server errors
            elif resp.status_code in (500, 504):
                # Request reached product service; hold may have been committed before error.
                # Must preserve UNKNOWN (is_ambiguous=True) to allow recovery using original reservation_op_id.
                last_error = f"Replica {replica} returned HTTP {resp.status_code}: {resp.text}"
                last_status = resp.status_code
                return ("UNKNOWN", None, f"HTTP_{resp.status_code}", last_error, True)

            elif resp.status_code in (502, 503):
                last_error = f"Replica {replica} returned HTTP {resp.status_code}"
                last_status = resp.status_code
                continue

            else:
                last_error = f"Replica {replica} returned unexpected HTTP {resp.status_code}: {resp.text}"
                last_status = resp.status_code
                return ("UNKNOWN", None, f"HTTP_{resp.status_code}", last_error, True)

        except (httpx.ConnectError, httpx.ConnectTimeout) as e:
            last_error = f"Connection error to {replica}: {e}"
            continue
        except (httpx.ReadTimeout, httpx.WriteTimeout) as e:
            return ("UNKNOWN", None, "TIMEOUT", f"Timeout communicating with {replica}: {e}", True)
        except Exception as e:
            last_error = str(e)
            continue

    # If all replicas experienced connection or gateway failures
    err_code = f"HTTP_{last_status}" if last_status else "CONNECT_FAILURE"
    return ("UNKNOWN", None, err_code, f"All replicas failed: {last_error}", True)

def get_reservation_internal(reservation_op_id: str) -> Tuple[Optional[str], Optional[dict], bool, bool]:
    """
    Probes reservation status from Product Service across available replicas.
    Returns: (status, response_data, is_expired, is_uncertain).
    Distinguishes verifiable terminal outcomes from uncertain outcomes:
    - 200 OK: definitive status from Product Service (is_uncertain=False).
    - 404 Not Found: ambiguous after initial reservation POST because the POST may
      still be in-flight; preserves UNKNOWN (is_uncertain=True).
    - 502/503/timeout/network errors: preserves UNKNOWN (is_uncertain=True).
    """
    replicas = get_product_service_replicas()
    headers = {"X-Internal-Secret": INTERNAL_API_KEY}
    
    for replica in replicas:
        try:
            with httpx.Client(timeout=httpx.Timeout(5.0, connect=3.0)) as client:
                resp = client.get(f"{replica}/internal/reservations/{reservation_op_id}", headers=headers)
            if resp.status_code == 200:
                data = resp.json()
                is_expired = False
                exp_str = data.get("expires_at")
                if not exp_str:
                    # Missing expiration metadata: do NOT assume valid!
                    is_expired = True
                else:
                    try:
                        exp_dt = datetime.fromisoformat(exp_str.replace("Z", "+00:00"))
                        if exp_dt.tzinfo is None:
                            exp_dt = exp_dt.replace(tzinfo=timezone.utc)
                        if datetime.now(timezone.utc) >= exp_dt:
                            is_expired = True
                    except Exception:
                        # Malformed expiration metadata: do NOT assume valid!
                        is_expired = True
                return (data.get("status"), data, is_expired, False)
            elif resp.status_code == 404:
                # 404 after ambiguous POST is not proof of permanent failure
                return ("NOT_FOUND", None, False, True)
            elif resp.status_code in (500, 502, 503, 504):
                continue
        except Exception:
            continue
    return ("UNKNOWN", None, False, True)

def release_reservation_internal(reservation_op_id: str) -> bool:
    """
    Durable, verifiable compensation release of held inventory on Product Service.
    Returns True only when Product Service confirms terminal release (RELEASED, EXPIRED)
    or confirmed terminal failure state.
    Returns False on HTTP 404, transport timeouts, network disconnects, or unavailable replicas,
    ensuring COMPENSATION_REQUIRED is retained until release is verifiable.
    HTTP 404 is NOT treated as verified release because the original reservation POST
    may still be in-flight; treating 404 as released risks leaving an orphaned ACTIVE hold.
    """
    replicas = get_product_service_replicas()
    headers = {"X-Internal-Secret": INTERNAL_API_KEY}
    for replica in replicas:
        try:
            with httpx.Client(timeout=httpx.Timeout(5.0, connect=3.0)) as client:
                resp = client.post(f"{replica}/internal/reservations/{reservation_op_id}/release", headers=headers)
            if resp.status_code == 200:
                data = resp.json()
                if data.get("status") in ("RELEASED", "EXPIRED"):
                    return True
            elif resp.status_code == 404:
                # HTTP 404 is NOT verified release!
                # The reservation POST may still be in-flight and commit ACTIVE.
                # Returning False preserves compensation state so subsequent recovery safely retries.
                return False
            elif resp.status_code == 409:
                try:
                    data = resp.json()
                    if data.get("failure_code") == "RESERVATION_EXPIRED" or data.get("status") in ("RELEASED", "EXPIRED"):
                        return True
                    if data.get("failure_code") == "ALREADY_CONFIRMED":
                        return False
                except Exception:
                    pass
            elif resp.status_code in (500, 502, 503, 504):
                continue
        except Exception:
            continue
    return False

def execute_verifiable_release(reservation_op_id: str) -> bool:
    """Verifiable release alias delegating to release_reservation_internal."""
    return release_reservation_internal(reservation_op_id)

# App setup
app = FastAPI(title="Order Service")

@app.middleware("http")
async def add_request_id_and_log(request: Request, call_next):
    request_id = request.headers.get("X-Request-ID") or str(uuid.uuid4())
    start_time = datetime.utcnow()
    
    response = await call_next(request)
    
    duration = (datetime.utcnow() - start_time).total_seconds()
    logger.info(
        '{"service": "order-service", "request_id": "%s", "method": "%s", "path": "%s", "status": %d, "duration": %f}',
        request_id, request.method, request.url.path, response.status_code, duration
    )
    response.headers["X-Request-ID"] = request_id
    return response

# Schemas
class OrderItemCreate(BaseModel):
    product_id: int
    quantity: int = Field(..., gt=0)

class OrderCreate(BaseModel):
    items: List[OrderItemCreate]
    coupon_id: Optional[int] = None

class CartItemAdd(BaseModel):
    product_id: int
    quantity: int = Field(..., gt=0)

class CartItemUpdate(BaseModel):
    quantity: int = Field(..., gt=0)

class CartItemDetail(BaseModel):
    cart_item_id: int
    product_id: int
    name: str
    quantity: int
    unit_price: Decimal
    subtotal: Decimal

class CartResponse(BaseModel):
    cart_id: int
    user_id: int
    items: List[CartItemDetail]
    total_items: int
    estimated_total: Decimal

class CheckoutRequest(BaseModel):
    coupon_code: Optional[str] = None
    payment_method: Optional[str] = None

class CheckoutItemSnapshot(BaseModel):
    product_id: int
    name: str
    quantity: int
    unit_price: Decimal
    subtotal: Decimal

class CheckoutResponse(BaseModel):
    checkout_id: int
    operation_id: str
    status: str
    order_id: Optional[int] = None
    total_amount: Decimal
    items: List[CheckoutItemSnapshot] = []
    failure_code: Optional[str] = None
    failure_reason: Optional[str] = None
    created_at: Optional[datetime] = None

class OrderItemResponse(BaseModel):
    order_item_id: int
    product_id: int
    quantity: int
    unit_price: float

class OrderResponse(BaseModel):
    order_id: int
    user_id: int
    status: str
    total_amount: float
    items: List[OrderItemResponse]

def get_current_user(x_user_sub: Optional[str] = Header(None), x_user_role: Optional[str] = Header(None)):
    if not x_user_sub:
        raise HTTPException(status_code=401, detail="Unauthenticated")
    return {"sub": x_user_sub, "role": x_user_role}

def require_internal(x_internal_secret: str = Header(...)):
    if x_internal_secret != INTERNAL_API_KEY:
        raise HTTPException(status_code=403, detail="Forbidden: Invalid internal secret")
    return True

def compute_request_options_fingerprint(coupon_code: Optional[str], items_summary: Optional[str] = None) -> str:
    data = {"coupon_code": coupon_code or ""}
    if items_summary:
        data["items"] = items_summary
    return hashlib.sha256(json.dumps(data, sort_keys=True).encode("utf-8")).hexdigest()

def build_checkout_response(chk: Checkout) -> CheckoutResponse:
    items_out = []
    for it in (chk.items_snapshot or []):
        items_out.append(CheckoutItemSnapshot(
            product_id=it["product_id"],
            name=it.get("name", f"Product {it['product_id']}"),
            quantity=it["quantity"],
            unit_price=Decimal(str(it["unit_price"])).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP),
            subtotal=Decimal(str(it["subtotal"])).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
        ))
    return CheckoutResponse(
        checkout_id=chk.checkout_id,
        operation_id=chk.operation_id,
        status=chk.status,
        order_id=chk.order_id,
        total_amount=Decimal(str(chk.total_amount)).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP),
        items=items_out,
        failure_code=chk.failure_code,
        failure_reason=chk.failure_reason,
        created_at=chk.created_at
    )

def assert_cart_not_locked(db: Session, user_id: int, current_idempotency_key: Optional[str] = None):
    query = db.query(Checkout).filter(
        Checkout.user_id == user_id,
        Checkout.status.in_(["INITIATED", "RESERVING", "UNKNOWN"])
    )
    if current_idempotency_key:
        query = query.filter(Checkout.idempotency_key != current_idempotency_key)
    active_chk = query.first()
    if active_chk:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Cart is currently locked by an in-progress checkout operation"
        )

def get_or_create_cart(db: Session, user_id: int) -> Cart:
    cart = db.query(Cart).filter(Cart.user_id == user_id).first()
    if not cart:
        try:
            cart = Cart(user_id=user_id)
            db.add(cart)
            db.commit()
            db.refresh(cart)
        except Exception:
            db.rollback()
            cart = db.query(Cart).filter(Cart.user_id == user_id).first()
            if not cart:
                raise HTTPException(status_code=500, detail="Failed to initialize cart")
    return cart

def build_cart_response(cart: Cart, request_id: str, authorization: Optional[str] = None) -> CartResponse:
    items_detail = []
    total_items = 0
    estimated_total = Decimal("0.00")

    for item in cart.items:
        try:
            product = fetch_product_with_breaker(item.product_id, request_id, authorization)
            name = product.get("name", f"Product {item.product_id}")
            unit_price = Decimal(str(product.get("price", "0.00"))).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
        except HTTPException as e:
            if e.status_code == 404:
                name = f"Product {item.product_id} (Unavailable)"
                unit_price = Decimal("0.00")
            else:
                raise HTTPException(status_code=503, detail="Product Service unavailable to calculate cart pricing")
        except Exception:
            raise HTTPException(status_code=503, detail="Product Service unavailable to calculate cart pricing")

        subtotal = (unit_price * Decimal(item.quantity)).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
        items_detail.append(CartItemDetail(
            cart_item_id=item.cart_item_id,
            product_id=item.product_id,
            name=name,
            quantity=item.quantity,
            unit_price=unit_price,
            subtotal=subtotal
        ))
        total_items += item.quantity
        estimated_total += subtotal

    return CartResponse(
        cart_id=cart.cart_id,
        user_id=cart.user_id,
        items=items_detail,
        total_items=total_items,
        estimated_total=estimated_total
    )

def reconcile_and_recover_checkout(checkout_id: int, clear_cart: bool = False, db: Optional[Session] = None) -> Checkout:
    """
    Durably resolves an incomplete checkout operation with strict 3-phase execution:
    - Phase A: Short local transaction to inspect record state, then commit/close.
    - Part B: Remote probe / idempotent reconciliation / verifiable release outside of any database transaction or row lock.
    - Phase C: Short local transaction with row-level lock (with_for_update) to recheck state and finalize.
    """
    use_external_db = (db is not None)
    active_db = db if use_external_db else SessionLocal()

    try:
        # ---------------------------------------------------------------------
        # Phase A: Inspect record state
        # ---------------------------------------------------------------------
        chk = active_db.query(Checkout).filter(Checkout.checkout_id == checkout_id).with_for_update().first()
        if not chk:
            active_db.commit()
            raise HTTPException(status_code=404, detail="Checkout not found")

        if chk.status in ("RESERVED", "FAILED", "CANCELLED") or chk.order_id is not None:
            active_db.commit()
            return chk

        current_status = chk.status
        res_op_id = chk.reservation_op_id
        items_snapshot = list(chk.items_snapshot or [])
        user_id = chk.user_id
        total_amount = chk.total_amount
        is_cart_checkout = (res_op_id or "").startswith("res_chk_")
        effective_clear_cart = clear_cart or is_cart_checkout

        # Commit and release locks before remote call
        active_db.commit()

        # ---------------------------------------------------------------------
        # Part B: Remote call outside database transaction
        # ---------------------------------------------------------------------
        if active_db.in_transaction():
            active_db.commit()
        assert not active_db.in_transaction(), "Database transaction active during Part B remote calls"

        res_status = None
        res_data = None
        is_expired = False
        is_uncertain = False
        released = False

        if current_status in ("INITIATED", "RESERVING", "UNKNOWN"):
            res_tuple = get_reservation_internal(res_op_id)
            if len(res_tuple) == 4:
                res_status, res_data, is_expired, is_uncertain = res_tuple
            else:
                res_status, res_data, is_expired = res_tuple
                is_uncertain = (res_status in (None, "NOT_FOUND", "UNKNOWN"))

            # DEFECT 1: If reservation lookup returns 404 (NOT_FOUND):
            # This occurs when Order Service crashed after committing checkout intent but
            # before transmitting the reservation POST, OR the original reservation POST is still in-flight.
            # Safely retry POST /internal/reservations using the SAME operation ID and items_snapshot.
            # Product Service's unique constraint serializes this against any in-flight request.
            if res_status == "NOT_FOUND":
                items_for_remote = [{"product_id": x["product_id"], "quantity": x["quantity"]} for x in items_snapshot]
                post_status, post_data, post_fail_code, post_fail_reason, post_ambiguous = reserve_inventory_internal(
                    res_op_id, items_for_remote
                )
                if post_status == "ACTIVE":
                    res_status = "ACTIVE"
                    res_data = post_data
                    is_uncertain = False
                    is_expired = False
                    exp_str = res_data.get("expires_at") if res_data else None
                    if not exp_str:
                        # Missing expiration metadata: do NOT assume valid!
                        is_expired = True
                    else:
                        try:
                            exp_dt = datetime.fromisoformat(exp_str.replace("Z", "+00:00"))
                            if exp_dt.tzinfo is None:
                                exp_dt = exp_dt.replace(tzinfo=timezone.utc)
                            if datetime.now(timezone.utc) >= exp_dt:
                                is_expired = True
                        except Exception:
                            # Malformed expiration metadata: do NOT assume valid!
                            is_expired = True
                elif post_status == "FAILED":
                    res_status = "FAILED"
                    res_data = post_data or {"failure_code": post_fail_code, "failure_reason": post_fail_reason}
                    is_uncertain = False
                else:
                    # Transient unavailability or timeout -> preserve UNKNOWN
                    res_status = "UNKNOWN"
                    is_uncertain = True

        elif current_status == "COMPENSATION_REQUIRED":
            if active_db.in_transaction():
                active_db.commit()
            assert not active_db.in_transaction(), "Database transaction active at compensation release network boundary"
            released = release_reservation_internal(res_op_id)

        # ---------------------------------------------------------------------
        # Phase C: Recheck state with row lock and finalize
        # ---------------------------------------------------------------------
        chk = active_db.query(Checkout).filter(Checkout.checkout_id == checkout_id).with_for_update().first()
        if not chk:
            active_db.commit()
            raise HTTPException(status_code=404, detail="Checkout not found")

        # Concurrent check: if another worker already finalized it
        if chk.status in ("RESERVED", "FAILED", "CANCELLED") or chk.order_id is not None:
            active_db.commit()
            return chk

        # Enforce strict state precedence:
        # If checkout has entered compensation, it CANNOT transition to RESERVED!
        if chk.status == "COMPENSATION_REQUIRED":
            if not released and chk.order_id is None and chk.status != "RESERVED":
                active_db.rollback()
                assert not active_db.in_transaction(), "Database transaction active at compensation release network boundary"
                released = release_reservation_internal(res_op_id)
                chk = active_db.query(Checkout).filter(Checkout.checkout_id == checkout_id).with_for_update().first()
                if not chk or chk.status in ("RESERVED", "FAILED", "CANCELLED") or chk.order_id is not None:
                    active_db.commit()
                    return chk

            if released:
                chk.status = "CANCELLED"
            else:
                chk.status = "COMPENSATION_REQUIRED"
            chk.updated_at = datetime.now(timezone.utc)
            active_db.commit()
            return chk

        if chk.status in ("INITIATED", "RESERVING", "UNKNOWN"):
            if res_status == "ACTIVE":
                # Recheck expiration AFTER acquiring finalization lock!
                exp_str = res_data.get("expires_at") if res_data else None
                lock_is_expired = False
                if not exp_str:
                    lock_is_expired = True
                else:
                    try:
                        exp_dt = datetime.fromisoformat(exp_str.replace("Z", "+00:00"))
                        if exp_dt.tzinfo is None:
                            exp_dt = exp_dt.replace(tzinfo=timezone.utc)
                        if datetime.now(timezone.utc) >= exp_dt:
                            lock_is_expired = True
                    except Exception:
                        lock_is_expired = True

                if lock_is_expired:
                    # Required sequence:
                    # A. Row lock is already held on chk
                    # B. Verify no order has been finalized
                    transitioned_to_comp = False
                    if chk and chk.order_id is None and chk.status != "RESERVED":
                        # C. Durably transition to COMPENSATION_REQUIRED
                        chk.status = "COMPENSATION_REQUIRED"
                        chk.failure_code = "RESERVATION_EXPIRED"
                        chk.failure_reason = "Reservation expired before checkout finalization could complete"
                        chk.updated_at = datetime.now(timezone.utc)
                        # D. Commit local transaction
                        active_db.commit()
                        transitioned_to_comp = True
                    else:
                        active_db.rollback()

                    if not transitioned_to_comp:
                        return chk

                    # E. Call Product Service outside any local transaction
                    if active_db.in_transaction():
                        active_db.commit()
                    assert not active_db.in_transaction(), "Database transaction active at compensation release network boundary"

                    released = release_reservation_internal(res_op_id)

                    # F. Open a new short transaction and record the verified outcome
                    try:
                        chk = active_db.query(Checkout).filter(Checkout.checkout_id == checkout_id).with_for_update().first()
                        if chk and chk.status == "COMPENSATION_REQUIRED" and chk.order_id is None:
                            if released:
                                chk.status = "FAILED"
                                chk.failure_code = "RESERVATION_EXPIRED"
                                chk.failure_reason = "Reservation expired before checkout finalization could complete"
                            else:
                                chk.status = "COMPENSATION_REQUIRED"
                                chk.failure_code = "RESERVATION_EXPIRED"
                                chk.failure_reason = "Reservation expired before checkout finalization could complete; release pending confirmation"
                            chk.updated_at = datetime.now(timezone.utc)
                            active_db.commit()
                        else:
                            active_db.rollback()
                    except Exception:
                        active_db.rollback()
                    return chk
                else:
                    # Exactly-once local order creation
                    if not chk.order_id:
                        new_order = Order(
                            user_id=chk.user_id,
                            status="Pending",
                            total_amount=chk.total_amount
                        )
                        active_db.add(new_order)
                        active_db.flush()

                        for it in (chk.items_snapshot or []):
                            order_item = OrderItem(
                                order_id=new_order.order_id,
                                product_id=it["product_id"],
                                quantity=it["quantity"],
                                unit_price=Decimal(str(it.get("unit_price") or it.get("price", "0.00")))
                            )
                            active_db.add(order_item)

                        chk.order_id = new_order.order_id

                        if effective_clear_cart:
                            cart = active_db.query(Cart).filter(Cart.user_id == chk.user_id).first()
                            if cart:
                                for it in (chk.items_snapshot or []):
                                    active_db.query(CartItemModel).filter(
                                        CartItemModel.cart_id == cart.cart_id,
                                        CartItemModel.product_id == it["product_id"]
                                    ).delete()
                                cart.updated_at = datetime.now(timezone.utc)

                    chk.status = "RESERVED"
                    chk.failure_code = None
                    chk.failure_reason = None

            elif res_status in ("FAILED", "RELEASED", "EXPIRED"):
                chk.status = "FAILED"
                chk.failure_code = (res_data.get("failure_code") if res_data else None) or "RESERVATION_FAILED"
                chk.failure_reason = (res_data.get("failure_reason") if res_data else None) or f"Reservation status: {res_status}"

            else:
                # Outcome uncertain (timeout or service unavailable)
                # Preserve UNKNOWN so subsequent recovery can reconcile!
                chk.status = "UNKNOWN"

        chk.updated_at = datetime.now(timezone.utc)
        active_db.commit()
        try:
            active_db.refresh(chk)
        except Exception:
            pass
        return chk
    finally:
        if not use_external_db:
            active_db.close()

def recover_single_checkout(db: Session, checkout_id: int) -> Checkout:
    """
    Durably resolves an incomplete checkout operation with strict 3-phase execution.
    """
    return reconcile_and_recover_checkout(checkout_id, db=db)

def execute_checkout_orchestration(
    user_id: int,
    idempotency_key: str,
    request_fingerprint: str,
    candidate_items: List[dict],
    clear_cart: bool,
    request_id: str,
    authorization: Optional[str] = None,
    db: Optional[Session] = None
) -> Tuple[Checkout, Optional[Order]]:
    """
    Unified, durable checkout orchestration shared between POST /checkout and legacy POST /orders.
    Ensures:
    - Concurrency-safe idempotency via PostgreSQL unique constraint
    - Zero database transactions or row locks held during remote calls or retry polling
    - Verifiable two-phase compensation on failure
    - Expiration checked immediately prior to local order finalization
    """
    use_external_db = (db is not None)
    active_db = db if use_external_db else SessionLocal()

    try:
        # ---------------------------------------------------------------------
        # 1. PRIORITY 1: Resolve existing checkout BEFORE initiating any new work
        # ---------------------------------------------------------------------
        existing = active_db.query(Checkout).filter(
            Checkout.user_id == user_id,
            Checkout.idempotency_key == idempotency_key
        ).first()

        existing_id = None
        existing_fingerprint = None
        existing_status = None
        existing_order_id = None
        existing_fail_code = None
        existing_fail_reason = None

        if existing:
            existing_id = existing.checkout_id
            existing_fingerprint = existing.request_fingerprint
            existing_status = existing.status
            existing_order_id = existing.order_id
            existing_fail_code = existing.failure_code
            existing_fail_reason = existing.failure_reason

        # Commit immediately so no database transaction remains open
        active_db.commit()

        if existing_id:
            if existing_fingerprint != request_fingerprint:
                raise HTTPException(
                    status_code=status.HTTP_409_CONFLICT,
                    detail="Idempotency-Key reused with conflicting payload options"
                )
            
            if existing_status == "RESERVED":
                order = active_db.query(Order).filter(Order.order_id == existing_order_id).first() if existing_order_id else None
                active_db.commit()
                chk = active_db.query(Checkout).filter(Checkout.checkout_id == existing_id).first()
                active_db.commit()
                return chk, order
            
            elif existing_status == "FAILED":
                status_code = status.HTTP_409_CONFLICT if existing_fail_code == "CONFLICT" else status.HTTP_400_BAD_REQUEST
                raise HTTPException(
                    status_code=status_code,
                    detail={
                        "message": "Checkout previously failed",
                        "failure_code": existing_fail_code,
                        "failure_reason": existing_fail_reason
                    }
                )
            elif existing_status == "CANCELLED":
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail={
                        "message": "Checkout previously cancelled",
                        "failure_code": existing_fail_code,
                        "failure_reason": existing_fail_reason
                    }
                )
            
            # Non-terminal state: poll briefly with NO database lock or open transaction held
            for _ in range(20):
                if active_db.in_transaction():
                    active_db.commit()
                time.sleep(0.1)
                chk_curr = active_db.query(Checkout).filter(Checkout.checkout_id == existing_id).first()
                if chk_curr:
                    curr_st = chk_curr.status
                    curr_oid = chk_curr.order_id
                    curr_fc = chk_curr.failure_code
                    curr_fr = chk_curr.failure_reason
                else:
                    curr_st = None
                active_db.commit()
                if curr_st in ("RESERVED", "FAILED", "CANCELLED"):
                    existing_status = curr_st
                    existing_order_id = curr_oid
                    existing_fail_code = curr_fc
                    existing_fail_reason = curr_fr
                    break

            if existing_status == "RESERVED":
                order = active_db.query(Order).filter(Order.order_id == existing_order_id).first() if existing_order_id else None
                active_db.commit()
                chk = active_db.query(Checkout).filter(Checkout.checkout_id == existing_id).first()
                active_db.commit()
                return chk, order
            elif existing_status == "FAILED":
                status_code = status.HTTP_409_CONFLICT if existing_fail_code == "CONFLICT" else status.HTTP_400_BAD_REQUEST
                raise HTTPException(
                    status_code=status_code,
                    detail={
                        "message": "Checkout previously failed",
                        "failure_code": existing_fail_code,
                        "failure_reason": existing_fail_reason
                    }
                )
            elif existing_status == "CANCELLED":
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail={
                        "message": "Checkout previously cancelled",
                        "failure_code": existing_fail_code,
                        "failure_reason": existing_fail_reason
                    }
                )

            # If still unresolved, trigger active recovery pass
            if active_db.in_transaction():
                active_db.commit()
            resolved = reconcile_and_recover_checkout(existing_id, clear_cart=clear_cart, db=active_db)
            if resolved.status == "RESERVED":
                order = active_db.query(Order).filter(Order.order_id == resolved.order_id).first() if resolved.order_id else None
                active_db.commit()
                return resolved, order
            elif resolved.status == "FAILED":
                status_code = status.HTTP_409_CONFLICT if resolved.failure_code == "CONFLICT" else status.HTTP_400_BAD_REQUEST
                raise HTTPException(
                    status_code=status_code,
                    detail={
                        "message": "Checkout failed during resolution",
                        "failure_code": resolved.failure_code,
                        "failure_reason": resolved.failure_reason
                    }
                )
            elif resolved.status == "CANCELLED":
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail={
                        "message": "Checkout previously cancelled",
                        "failure_code": resolved.failure_code,
                        "failure_reason": resolved.failure_reason
                    }
                )
            else:
                raise HTTPException(
                    status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                    detail="Checkout operation is currently resolving; please retry shortly"
                )

        # ---------------------------------------------------------------------
        # 2. PRIORITY 2: New checkout initiation
        # Fetch authoritative prices OUTSIDE any transaction
        # ---------------------------------------------------------------------
        if not candidate_items:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Cannot checkout without items")

        if active_db.in_transaction():
            active_db.commit()
        assert not active_db.in_transaction(), "Database transaction active before pricing requests"

        detailed_snapshot = []
        total_amount = Decimal("0.00")

        for it in candidate_items:
            try:
                prod = fetch_product_with_breaker(it["product_id"], request_id, authorization)
                price = Decimal(str(prod["price"])).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
                subtotal = (price * Decimal(it["quantity"])).quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
                total_amount += subtotal
                detailed_snapshot.append({
                    "product_id": it["product_id"],
                    "name": prod.get("name", f"Product {it['product_id']}"),
                    "quantity": it["quantity"],
                    "unit_price": str(price),
                    "subtotal": str(subtotal)
                })
            except HTTPException as e:
                if e.status_code == 404:
                    raise HTTPException(status_code=404, detail=f"Product {it['product_id']} not found")
                raise HTTPException(status_code=503, detail="Product Service unavailable to price cart items")
            except Exception:
                raise HTTPException(status_code=503, detail="Product Service unavailable to price cart items")

        operation_id = str(uuid.uuid4())
        prefix = "res_chk" if clear_cart else "res_ord"
        reservation_op_id = f"{prefix}_{operation_id}"

        # ---------------------------------------------------------------------
        # 3. TX 1: Short local transaction to persist checkout in RESERVING state
        # ---------------------------------------------------------------------
        created_checkout_id = None
        try:
            if clear_cart:
                cart = active_db.query(Cart).filter(Cart.user_id == user_id).with_for_update().first()
                if not cart:
                    active_db.rollback()
                    raise HTTPException(status_code=400, detail="Cart not found")
                current_items = [
                    {"product_id": item.product_id, "quantity": item.quantity}
                    for item in sorted(cart.items, key=lambda x: x.product_id)
                ]
                if current_items != candidate_items:
                    active_db.rollback()
                    raise HTTPException(
                        status_code=status.HTTP_409_CONFLICT,
                        detail="Cart contents changed during checkout initiation; please retry"
                    )
                assert_cart_not_locked(active_db, user_id, current_idempotency_key=idempotency_key)

            new_checkout = Checkout(
                user_id=user_id,
                operation_id=operation_id,
                idempotency_key=idempotency_key,
                request_fingerprint=request_fingerprint,
                reservation_op_id=reservation_op_id,
                status="RESERVING",
                total_amount=total_amount,
                items_snapshot=detailed_snapshot
            )
            active_db.add(new_checkout)
            active_db.flush()
            created_checkout_id = new_checkout.checkout_id
            active_db.commit()
            # CRITICAL: Do NOT call active_db.refresh(new_checkout)!
            # Refresh executes a SELECT which starts a new transaction on active_db.
        except IntegrityError:
            active_db.rollback()
            # Concurrent race on (user_id, idempotency_key)
            winner = active_db.query(Checkout).filter(
                Checkout.user_id == user_id,
                Checkout.idempotency_key == idempotency_key
            ).first()
            if winner:
                w_id = winner.checkout_id
                w_fingerprint = winner.request_fingerprint
                w_status = winner.status
                w_order_id = winner.order_id
                w_fail_code = winner.failure_code
                w_fail_reason = winner.failure_reason
                active_db.commit()

                if w_fingerprint != request_fingerprint:
                    raise HTTPException(status_code=409, detail="Idempotency-Key reused with conflicting payload options")

                for _ in range(20):
                    if active_db.in_transaction():
                        active_db.commit()
                    time.sleep(0.1)
                    w_curr = active_db.query(Checkout).filter(Checkout.checkout_id == w_id).first()
                    if w_curr:
                        curr_st = w_curr.status
                        curr_oid = w_curr.order_id
                        curr_fc = w_curr.failure_code
                        curr_fr = w_curr.failure_reason
                    else:
                        curr_st = None
                    active_db.commit()
                    if curr_st in ("RESERVED", "FAILED", "CANCELLED"):
                        w_status = curr_st
                        w_order_id = curr_oid
                        w_fail_code = curr_fc
                        w_fail_reason = curr_fr
                        break

                if w_status == "RESERVED":
                    order = active_db.query(Order).filter(Order.order_id == w_order_id).first() if w_order_id else None
                    active_db.commit()
                    chk = active_db.query(Checkout).filter(Checkout.checkout_id == w_id).first()
                    active_db.commit()
                    return chk, order
                elif w_status == "FAILED":
                    status_code = status.HTTP_409_CONFLICT if w_fail_code == "CONFLICT" else status.HTTP_400_BAD_REQUEST
                    raise HTTPException(
                        status_code=status_code,
                        detail={"message": "Checkout previously failed", "failure_code": w_fail_code, "failure_reason": w_fail_reason}
                    )
                elif w_status == "CANCELLED":
                    raise HTTPException(
                        status_code=status.HTTP_400_BAD_REQUEST,
                        detail={"message": "Checkout previously cancelled", "failure_code": w_fail_code, "failure_reason": w_fail_reason}
                    )
                
                if active_db.in_transaction():
                    active_db.commit()
                resolved = reconcile_and_recover_checkout(w_id, clear_cart=clear_cart, db=active_db)
                if resolved.status == "RESERVED":
                    order = active_db.query(Order).filter(Order.order_id == resolved.order_id).first() if resolved.order_id else None
                    active_db.commit()
                    return resolved, order
                elif resolved.status == "FAILED":
                    status_code = status.HTTP_409_CONFLICT if resolved.failure_code == "CONFLICT" else status.HTTP_400_BAD_REQUEST
                    raise HTTPException(
                        status_code=status_code,
                        detail={"message": "Checkout failed during resolution", "failure_code": resolved.failure_code, "failure_reason": resolved.failure_reason}
                    )
            raise HTTPException(status_code=409, detail="Concurrent checkout conflict")
        except HTTPException:
            active_db.rollback()
            raise
        except Exception as e:
            active_db.rollback()
            raise HTTPException(status_code=500, detail=f"Failed to persist checkout: {e}")

        # ---------------------------------------------------------------------
        # 4. Remote call to Product Service (NO DATABASE TRANSACTION OPEN)
        # ---------------------------------------------------------------------
        if active_db.in_transaction():
            active_db.commit()
        assert not active_db.in_transaction(), "Database transaction active before reserve_inventory_internal"

        items_for_remote = [{"product_id": x["product_id"], "quantity": x["quantity"]} for x in candidate_items]
        res_status, res_data, fail_code, fail_reason, is_ambiguous = reserve_inventory_internal(
            reservation_op_id, items_for_remote
        )

        # ---------------------------------------------------------------------
        # 5. TX 2: Finalize order, fail, or trigger compensation
        # ---------------------------------------------------------------------
        if res_status == "ACTIVE":
            # -----------------------------------------------------------------
            # Step 1: Acquire checkout row lock for finalization
            # -----------------------------------------------------------------
            if active_db.in_transaction():
                active_db.commit()

            chk = active_db.query(Checkout).filter(Checkout.checkout_id == created_checkout_id).with_for_update().first()
            if not chk:
                active_db.commit()
                raise HTTPException(status_code=404, detail="Checkout not found")

            # Check if concurrent recovery or process already finalized it or initiated compensation
            if chk.status in ("RESERVED", "FAILED", "CANCELLED", "COMPENSATION_REQUIRED"):
                active_db.commit()
                if chk.status == "RESERVED":
                    order_obj = active_db.query(Order).filter(Order.order_id == chk.order_id).first() if chk.order_id else None
                    active_db.commit()
                    return chk, order_obj
                elif chk.status == "COMPENSATION_REQUIRED":
                    raise HTTPException(
                        status_code=status.HTTP_409_CONFLICT,
                        detail={
                            "message": "Checkout is currently undergoing compensation; cannot finalize order",
                            "failure_code": chk.failure_code,
                            "failure_reason": chk.failure_reason
                        }
                    )
                elif chk.status == "CANCELLED":
                    raise HTTPException(
                        status_code=status.HTTP_400_BAD_REQUEST,
                        detail={
                            "message": "Checkout previously cancelled",
                            "failure_code": chk.failure_code,
                            "failure_reason": chk.failure_reason
                        }
                    )
                elif chk.status == "FAILED":
                    status_code = status.HTTP_409_CONFLICT if chk.failure_code == "CONFLICT" else status.HTTP_400_BAD_REQUEST
                    raise HTTPException(
                        status_code=status_code,
                        detail={
                            "message": "Checkout previously failed",
                            "failure_code": chk.failure_code,
                            "failure_reason": chk.failure_reason
                        }
                    )

            # -----------------------------------------------------------------
            # Step 2: RECHECK EXPIRATION AFTER ACQUIRING FINALIZATION LOCK!
            # -----------------------------------------------------------------
            exp_str = res_data.get("expires_at") if res_data else None
            is_expired = False
            if not exp_str:
                # Missing metadata: fail closed
                is_expired = True
            else:
                try:
                    exp_dt = datetime.fromisoformat(exp_str.replace("Z", "+00:00"))
                    if exp_dt.tzinfo is None:
                        exp_dt = exp_dt.replace(tzinfo=timezone.utc)
                    if datetime.now(timezone.utc) >= exp_dt:
                        is_expired = True
                except Exception:
                    # Malformed metadata: fail closed
                    is_expired = True

            if is_expired:
                # Do NOT create an order!
                # Required sequence:
                # A. Row lock is already held on chk
                # B. Verify no order has been finalized
                transitioned_to_comp = False
                try:
                    if chk and chk.status != "RESERVED" and chk.order_id is None:
                        # C. Durably transition to COMPENSATION_REQUIRED
                        chk.status = "COMPENSATION_REQUIRED"
                        chk.failure_code = "RESERVATION_EXPIRED"
                        chk.failure_reason = "Reservation expired before checkout finalization could complete"
                        chk.updated_at = datetime.now(timezone.utc)
                        # D. Commit local transaction
                        active_db.commit()
                        transitioned_to_comp = True
                    else:
                        active_db.rollback()
                except Exception:
                    active_db.rollback()
                    transitioned_to_comp = False

                if not transitioned_to_comp:
                    raise HTTPException(
                        status_code=500,
                        detail="Reservation expired, but compensation status could not be durably recorded."
                    )

                # E. Call Product Service outside any local transaction
                if active_db.in_transaction():
                    active_db.commit()
                assert not active_db.in_transaction(), "Database transaction active at compensation release network boundary"

                released = release_reservation_internal(reservation_op_id)

                # F. Open a new short transaction and record the verified outcome
                try:
                    chk = active_db.query(Checkout).filter(
                        Checkout.checkout_id == created_checkout_id
                    ).with_for_update().first()
                    if chk and chk.status == "COMPENSATION_REQUIRED" and chk.order_id is None:
                        if released:
                            chk.status = "FAILED"
                            chk.failure_code = "RESERVATION_EXPIRED"
                            chk.failure_reason = "Reservation expired before checkout finalization could complete"
                        else:
                            # Release not verified: preserve COMPENSATION_REQUIRED
                            chk.status = "COMPENSATION_REQUIRED"
                            chk.failure_code = "RESERVATION_EXPIRED"
                            chk.failure_reason = "Reservation expired before checkout finalization could complete; release pending confirmation"
                        chk.updated_at = datetime.now(timezone.utc)
                        active_db.commit()
                    else:
                        active_db.rollback()
                except Exception:
                    active_db.rollback()

                if released:
                    raise HTTPException(
                        status_code=status.HTTP_400_BAD_REQUEST,
                        detail={
                            "message": "Inventory reservation expired before finalization",
                            "failure_code": "RESERVATION_EXPIRED",
                            "failure_reason": "Reservation expired before checkout finalization could complete"
                        }
                    )
                else:
                    raise HTTPException(
                        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                        detail={
                            "message": "Reservation expired and compensation release is pending; please retry to resolve.",
                            "failure_code": "RESERVATION_EXPIRED",
                            "failure_reason": "Reservation expired before checkout finalization could complete; release pending confirmation"
                        }
                    )

            # -----------------------------------------------------------------
            # Step 3: Local order persistence (Pre-commit vs Post-commit separation)
            # -----------------------------------------------------------------
            committed_successfully = False
            pre_commit_phase = True
            new_order = None
            try:
                # Re-verify checkout state before assembling and committing order:
                # Never finalize an order for a checkout that has entered compensation!
                if chk.status in ("COMPENSATION_REQUIRED", "CANCELLED", "FAILED"):
                    active_db.rollback()
                    raise HTTPException(
                        status_code=status.HTTP_409_CONFLICT,
                        detail={
                            "message": "Checkout is in compensation or terminal failure; cannot finalize order",
                            "failure_code": chk.failure_code,
                            "failure_reason": chk.failure_reason
                        }
                    )

                if not chk.order_id:
                    new_order = Order(
                        user_id=user_id,
                        status="Pending",
                        total_amount=chk.total_amount
                    )
                    active_db.add(new_order)
                    active_db.flush()

                    for it in chk.items_snapshot:
                        order_item = OrderItem(
                            order_id=new_order.order_id,
                            product_id=it["product_id"],
                            quantity=it["quantity"],
                            unit_price=Decimal(str(it.get("unit_price") or it.get("price", "0.00")))
                        )
                        active_db.add(order_item)

                    chk.order_id = new_order.order_id

                    if clear_cart:
                        cart = active_db.query(Cart).filter(Cart.user_id == user_id).first()
                        if cart:
                            for it in chk.items_snapshot:
                                active_db.query(CartItemModel).filter(
                                    CartItemModel.cart_id == cart.cart_id,
                                    CartItemModel.product_id == it["product_id"]
                                ).delete()
                            cart.updated_at = datetime.now(timezone.utc)

                chk.status = "RESERVED"
                chk.updated_at = datetime.now(timezone.utc)
                pre_commit_phase = False
                active_db.commit()
                committed_successfully = True
            except HTTPException:
                raise
            except Exception as e:
                # Pre-commit failure or ambiguous commit outcome
                try:
                    active_db.rollback()
                except Exception:
                    pass

                inspection_successful = False
                commit_proven_failed = False

                if not pre_commit_phase:
                    # Ambiguous commit outcome: commit() was invoked and raised an exception.
                    # Inspect persisted checkout/order state via an independent database session.
                    try:
                        inspect_Session = sessionmaker(bind=active_db.get_bind())
                        inspect_db = inspect_Session()
                        try:
                            persisted_chk = inspect_db.query(Checkout).filter(
                                Checkout.checkout_id == created_checkout_id
                            ).first()
                            if persisted_chk:
                                inspection_successful = True
                                if persisted_chk.status == "RESERVED" and persisted_chk.order_id:
                                    committed_successfully = True
                                # Note: finding RESERVING/UNKNOWN/order_id=None does NOT prove
                                # rollback because the commit outcome is uncertain. Do NOT infer rollback!
                        finally:
                            inspect_db.close()
                    except Exception as inspect_err:
                        logger.warning(f"Ambiguous commit inspection failed: {inspect_err}")
                        inspection_successful = False
                else:
                    # Exception occurred before active_db.commit() was ever called.
                    # Transaction was definitely not committed to the database.
                    commit_proven_failed = True

                if committed_successfully:
                    # Order commit was successfully persisted on the database!
                    pass
                elif not commit_proven_failed:
                    # Ambiguous commit outcome: commit() was called, but inspection failed or could not establish state.
                    # DO NOT assume transaction rolled back!
                    # DO NOT release reservation!
                    # DO NOT mark CANCELLED!
                    # Preserve original checkout and reservation operation IDs.
                    # Return retryable error without claiming cancellation.
                    logger.warning(
                        f"Ambiguous commit outcome for checkout {created_checkout_id}; inspection inconclusive. "
                        f"Preserving reservation {reservation_op_id} and returning retryable error."
                    )
                    try:
                        chk = active_db.query(Checkout).filter(Checkout.checkout_id == created_checkout_id).with_for_update().first()
                        if chk and chk.status not in ("RESERVED", "COMPENSATION_REQUIRED", "CANCELLED", "FAILED"):
                            chk.status = "UNKNOWN"
                            chk.failure_code = "AMBIGUOUS_COMMIT"
                            chk.failure_reason = str(e)
                            chk.updated_at = datetime.now(timezone.utc)
                            active_db.commit()
                    except Exception:
                        try:
                            active_db.rollback()
                        except Exception:
                            pass

                    raise HTTPException(
                        status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                        detail="Checkout commit outcome ambiguous; please retry with the same Idempotency-Key."
                    )
                else:
                    # Genuinely a proven pre-commit failure -> COMPENSATION REQUIRED!
                    transitioned_to_comp = False
                    try:
                        chk = active_db.query(Checkout).filter(Checkout.checkout_id == created_checkout_id).with_for_update().first()
                        if chk and chk.status != "RESERVED" and chk.order_id is None:
                            chk.status = "COMPENSATION_REQUIRED"
                            chk.failure_code = "ORDER_PERSISTENCE_FAILED"
                            chk.failure_reason = str(e)
                            chk.updated_at = datetime.now(timezone.utc)
                            active_db.commit()
                            transitioned_to_comp = True
                        else:
                            active_db.rollback()
                    except Exception:
                        active_db.rollback()
                        transitioned_to_comp = False

                    # If transition cannot be committed, do NOT issue release!
                    if not transitioned_to_comp:
                        raise HTTPException(
                            status_code=500,
                            detail="Checkout failed during order finalization; compensation transition could not be committed."
                        )

                    # E. Call Product Service outside any transaction
                    if active_db.in_transaction():
                        active_db.commit()
                    assert not active_db.in_transaction(), "Database transaction active at compensation release network boundary"

                    released = release_reservation_internal(reservation_op_id)

                    # F. Open new short transaction and record verified outcome
                    try:
                        chk = active_db.query(Checkout).filter(Checkout.checkout_id == created_checkout_id).with_for_update().first()
                        if chk and chk.status == "COMPENSATION_REQUIRED" and chk.order_id is None:
                            if released:
                                chk.status = "CANCELLED"
                            else:
                                chk.status = "COMPENSATION_REQUIRED"
                            chk.updated_at = datetime.now(timezone.utc)
                            active_db.commit()
                        else:
                            active_db.rollback()
                    except Exception:
                        active_db.rollback()

                    raise HTTPException(
                        status_code=500,
                        detail="Checkout failed during order finalization; inventory hold compensation initiated."
                    )

            # -----------------------------------------------------------------
            # Step 4: Post-commit response formatting
            # -----------------------------------------------------------------
            if committed_successfully:
                try:
                    read_chk = active_db.query(Checkout).filter(Checkout.checkout_id == created_checkout_id).first()
                    order_obj = active_db.query(Order).filter(Order.order_id == read_chk.order_id).first() if (read_chk and read_chk.order_id) else None
                    if active_db.in_transaction():
                        active_db.commit()
                    return read_chk or chk, order_obj
                except Exception as post_err:
                    logger.warning(f"Post-commit response building failed for checkout {created_checkout_id}: {post_err}")
                    if active_db.in_transaction():
                        try:
                            active_db.rollback()
                        except Exception:
                            pass
                    raise HTTPException(
                        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                        detail="Order successfully created, but failed to format immediate response. Retry request with the same Idempotency-Key to retrieve your order."
                    )

        elif res_status == "FAILED":
            try:
                chk = active_db.query(Checkout).filter(Checkout.checkout_id == created_checkout_id).with_for_update().first()
                if chk:
                    chk.status = "FAILED"
                    chk.failure_code = fail_code or "RESERVATION_FAILED"
                    chk.failure_reason = fail_reason
                    chk.updated_at = datetime.now(timezone.utc)
                    active_db.commit()
            except Exception:
                active_db.rollback()

            status_code = status.HTTP_400_BAD_REQUEST
            if fail_code == "PRODUCT_NOT_FOUND":
                status_code = status.HTTP_404_NOT_FOUND
            elif fail_code in ("CONFLICT", "CONFLICTING_PAYLOAD"):
                status_code = status.HTTP_409_CONFLICT

            raise HTTPException(
                status_code=status_code,
                detail={
                    "message": "Inventory reservation failed",
                    "failure_code": fail_code,
                    "failure_reason": fail_reason
                }
            )

        else:
            # Ambiguous outcome (res_status == "UNKNOWN" / network timeout)
            try:
                chk = active_db.query(Checkout).filter(Checkout.checkout_id == created_checkout_id).with_for_update().first()
                if chk:
                    chk.status = "UNKNOWN"
                    chk.failure_code = fail_code
                    chk.failure_reason = fail_reason
                    chk.updated_at = datetime.now(timezone.utc)
                    active_db.commit()
            except Exception:
                active_db.rollback()

            # Immediate recovery attempt outside transaction
            if active_db.in_transaction():
                active_db.commit()
            recovered = reconcile_and_recover_checkout(created_checkout_id, clear_cart=clear_cart, db=active_db)
            if recovered.status == "RESERVED":
                order = active_db.query(Order).filter(Order.order_id == recovered.order_id).first() if recovered.order_id else None
                active_db.commit()
                return recovered, order
            elif recovered.status == "FAILED":
                status_code = status.HTTP_409_CONFLICT if recovered.failure_code in ("CONFLICT", "CONFLICTING_PAYLOAD") else status.HTTP_400_BAD_REQUEST
                if recovered.failure_code == "PRODUCT_NOT_FOUND":
                    status_code = status.HTTP_404_NOT_FOUND
                raise HTTPException(
                    status_code=status_code,
                    detail={"message": "Checkout failed during resolution", "failure_code": recovered.failure_code, "failure_reason": recovered.failure_reason}
                )
            else:
                raise HTTPException(
                    status_code=status.HTTP_504_GATEWAY_TIMEOUT,
                    detail="Checkout outcome ambiguous; reservation is resolving. Please retry with the same Idempotency-Key."
                )

    finally:
        if not use_external_db:
            active_db.close()

# Checkout Route
@app.post("/checkout", response_model=CheckoutResponse, status_code=status.HTTP_201_CREATED)
def checkout(
    request: Request,
    response: Response,
    checkout_req: Optional[CheckoutRequest] = None,
    idempotency_key: str = Header(..., alias="Idempotency-Key"),
    db: Session = Depends(get_db),
    user: dict = Depends(get_current_user)
):
    user_id = int(user["sub"])
    request_id = request.headers.get("X-Request-ID") or str(uuid.uuid4())
    authorization = request.headers.get("Authorization")

    coupon_code = checkout_req.coupon_code if checkout_req else None
    request_fingerprint = compute_request_options_fingerprint(coupon_code)

    # Check candidate items from Cart in short read
    candidate_cart = db.query(Cart).filter(Cart.user_id == user_id).first()
    candidate_items = []
    if candidate_cart and candidate_cart.items:
        candidate_items = [
            {"product_id": item.product_id, "quantity": item.quantity}
            for item in sorted(candidate_cart.items, key=lambda x: x.product_id)
        ]

    # Check if existing checkout already exists for this idempotency key:
    existing = db.query(Checkout).filter(
        Checkout.user_id == user_id,
        Checkout.idempotency_key == idempotency_key
    ).first()
    has_existing = (existing is not None)

    # CRITICAL: Commit db transaction so no transaction is open before execute_checkout_orchestration!
    db.commit()

    if not has_existing and not candidate_items:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Cannot checkout empty cart")

    chk, order = execute_checkout_orchestration(
        user_id=user_id,
        idempotency_key=idempotency_key,
        request_fingerprint=request_fingerprint,
        candidate_items=candidate_items,
        clear_cart=True,
        request_id=request_id,
        authorization=authorization,
        db=db
    )

    if existing and chk.status == "RESERVED":
        response.status_code = status.HTTP_200_OK

    try:
        return build_checkout_response(chk)
    except Exception as e:
        logger.warning(f"Failed to build checkout response for checkout {chk.checkout_id}: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Order successfully created, but failed to format immediate response. Retry request with the same Idempotency-Key to retrieve your order."
        )

# Protected Internal Recovery Route
@app.post("/internal/checkout/recover", dependencies=[Depends(require_internal)])
def trigger_recovery(checkout_id: Optional[int] = None, db: Session = Depends(get_db)):
    if checkout_id:
        recovered = recover_single_checkout(db, checkout_id)
        return build_checkout_response(recovered)
    else:
        pending_ids = [
            r[0] for r in db.query(Checkout.checkout_id).filter(
                Checkout.status.in_(["INITIATED", "RESERVING", "UNKNOWN", "COMPENSATION_REQUIRED"])
            ).all()
        ]
        db.commit()
        results = []
        for cid in pending_ids:
            try:
                rec = recover_single_checkout(db, cid)
                results.append({"checkout_id": rec.checkout_id, "status": rec.status})
            except Exception as e:
                results.append({"checkout_id": cid, "error": str(e)})
        return {"recovered_count": len(results), "results": results}

# Legacy Order Route
@app.post("/orders", response_model=OrderResponse)
def create_order(
    order_req: OrderCreate, 
    request: Request,
    idempotency_key: Optional[str] = Header(None, alias="Idempotency-Key"),
    db: Session = Depends(get_db), 
    user=Depends(get_current_user)
):
    if not idempotency_key:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Idempotency-Key header is required for order creation. Please provide an Idempotency-Key header or use POST /api/checkout for cart checkout."
        )

    user_id = int(user["sub"])
    request_id = request.headers.get("X-Request-ID") or str(uuid.uuid4())
    authorization = request.headers.get("Authorization")

    items_sorted = sorted(order_req.items, key=lambda x: x.product_id)
    if not items_sorted:
        raise HTTPException(status_code=400, detail="Order must contain at least one item")

    items_summary = json.dumps([{"product_id": x.product_id, "quantity": x.quantity} for x in items_sorted])
    request_fingerprint = compute_request_options_fingerprint(None, items_summary=items_summary)
    candidate_items = [{"product_id": x.product_id, "quantity": x.quantity} for x in items_sorted]

    if db.in_transaction():
        db.commit()

    chk, order = execute_checkout_orchestration(
        user_id=user_id,
        idempotency_key=idempotency_key,
        request_fingerprint=request_fingerprint,
        candidate_items=candidate_items,
        clear_cart=False,
        request_id=request_id,
        authorization=authorization,
        db=db
    )

    if not order and chk.order_id:
        order = db.query(Order).filter(Order.order_id == chk.order_id).first()

    if not order:
        raise HTTPException(status_code=500, detail="Order record missing after checkout reservation")

    return OrderResponse(
        order_id=order.order_id,
        user_id=order.user_id,
        status=order.status,
        total_amount=float(order.total_amount),
        items=[
            OrderItemResponse(
                order_item_id=i.order_item_id,
                product_id=i.product_id,
                quantity=i.quantity,
                unit_price=float(i.unit_price)
            ) for i in order.items
        ]
    )

@app.get("/orders", response_model=List[OrderResponse])
def get_orders(db: Session = Depends(get_db), user=Depends(get_current_user)):
    user_id = int(user["sub"])
    role = user["role"]
    
    if role == "admin":
        orders = db.query(Order).all()
    else:
        orders = db.query(Order).filter(Order.user_id == user_id).all()
        
    res = []
    for o in orders:
        res_items = [
            OrderItemResponse(
                order_item_id=i.order_item_id,
                product_id=i.product_id,
                quantity=i.quantity,
                unit_price=float(i.unit_price)
            ) for i in o.items
        ]
        res.append(OrderResponse(
            order_id=o.order_id,
            user_id=o.user_id,
            status=o.status,
            total_amount=float(o.total_amount),
            items=res_items
        ))
    return res

# Cart Routes with Lock Discipline
@app.get("/cart", response_model=CartResponse)
def get_cart(
    request: Request,
    db: Session = Depends(get_db),
    user: dict = Depends(get_current_user)
):
    user_id = int(user["sub"])
    request_id = request.headers.get("X-Request-ID") or str(uuid.uuid4())
    authorization = request.headers.get("Authorization")
    cart = get_or_create_cart(db, user_id)
    return build_cart_response(cart, request_id, authorization)

@app.post("/cart/items", response_model=CartResponse)
def add_cart_item(
    item_in: CartItemAdd,
    request: Request,
    db: Session = Depends(get_db),
    user: dict = Depends(get_current_user)
):
    user_id = int(user["sub"])
    request_id = request.headers.get("X-Request-ID") or str(uuid.uuid4())
    authorization = request.headers.get("Authorization")
    
    # Validate product exists in Product Service
    try:
        fetch_product_with_breaker(item_in.product_id, request_id, authorization)
    except HTTPException as e:
        if e.status_code == 404:
            raise HTTPException(status_code=404, detail=f"Product {item_in.product_id} not found")
        raise HTTPException(status_code=503, detail="Product Service unavailable")
    except Exception:
        raise HTTPException(status_code=503, detail="Product Service unavailable")

    # Short transaction with cart row lock & lock discipline
    cart = get_or_create_cart(db, user_id)
    try:
        cart_locked = db.query(Cart).filter(Cart.cart_id == cart.cart_id).with_for_update().first()
        assert_cart_not_locked(db, user_id)

        existing_item = db.query(CartItemModel).filter(
            CartItemModel.cart_id == cart_locked.cart_id,
            CartItemModel.product_id == item_in.product_id
        ).first()

        if existing_item:
            existing_item.quantity += item_in.quantity
        else:
            new_item = CartItemModel(
                cart_id=cart_locked.cart_id,
                product_id=item_in.product_id,
                quantity=item_in.quantity
            )
            db.add(new_item)

        cart_locked.updated_at = datetime.utcnow()
        db.commit()
    except Exception:
        db.rollback()
        raise

    db.refresh(cart)
    return build_cart_response(cart, request_id, authorization)

@app.patch("/cart/items/{item_id}", response_model=CartResponse)
def update_cart_item(
    item_id: int,
    item_update: CartItemUpdate,
    request: Request,
    db: Session = Depends(get_db),
    user: dict = Depends(get_current_user)
):
    user_id = int(user["sub"])
    request_id = request.headers.get("X-Request-ID") or str(uuid.uuid4())
    authorization = request.headers.get("Authorization")
    
    cart = get_or_create_cart(db, user_id)
    try:
        cart_locked = db.query(Cart).filter(Cart.cart_id == cart.cart_id).with_for_update().first()
        assert_cart_not_locked(db, user_id)

        cart_item = db.query(CartItemModel).filter(
            CartItemModel.cart_item_id == item_id,
            CartItemModel.cart_id == cart_locked.cart_id
        ).first()

        if not cart_item:
            raise HTTPException(status_code=404, detail="Cart item not found")

        cart_item.quantity = item_update.quantity
        cart_locked.updated_at = datetime.utcnow()
        db.commit()
    except Exception:
        db.rollback()
        raise

    db.refresh(cart)
    return build_cart_response(cart, request_id, authorization)

@app.delete("/cart/items/{item_id}")
def delete_cart_item(
    item_id: int,
    db: Session = Depends(get_db),
    user: dict = Depends(get_current_user)
):
    user_id = int(user["sub"])
    cart = get_or_create_cart(db, user_id)
    try:
        cart_locked = db.query(Cart).filter(Cart.cart_id == cart.cart_id).with_for_update().first()
        assert_cart_not_locked(db, user_id)

        cart_item = db.query(CartItemModel).filter(
            CartItemModel.cart_item_id == item_id,
            CartItemModel.cart_id == cart_locked.cart_id
        ).first()

        if not cart_item:
            raise HTTPException(status_code=404, detail="Cart item not found")

        db.delete(cart_item)
        cart_locked.updated_at = datetime.utcnow()
        db.commit()
    except Exception:
        db.rollback()
        raise

    return {"message": "Item removed from cart"}

@app.delete("/cart")
def empty_cart(
    db: Session = Depends(get_db),
    user: dict = Depends(get_current_user)
):
    user_id = int(user["sub"])
    cart = get_or_create_cart(db, user_id)
    try:
        cart_locked = db.query(Cart).filter(Cart.cart_id == cart.cart_id).with_for_update().first()
        assert_cart_not_locked(db, user_id)

        db.query(CartItemModel).filter(CartItemModel.cart_id == cart_locked.cart_id).delete()
        cart_locked.updated_at = datetime.utcnow()
        db.commit()
    except Exception:
        db.rollback()
        raise

    return {"message": "Cart emptied successfully"}

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
