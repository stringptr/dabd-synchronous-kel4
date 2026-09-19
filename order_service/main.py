import os
import uuid
import logging
from datetime import datetime
from decimal import Decimal, ROUND_HALF_UP
from typing import Optional, List

from fastapi import FastAPI, Depends, HTTPException, status, Request, Response, Header
from pydantic import BaseModel, Field
from sqlalchemy import create_engine, Column, Integer, String, Float, DateTime, ForeignKey, text, Numeric, Table, UniqueConstraint, CheckConstraint
from sqlalchemy.orm import sessionmaker, declarative_base, Session, relationship
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

SQLALCHEMY_DATABASE_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
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

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Product Service setup
PRODUCT_SERVICE_URL = os.getenv("PRODUCT_SERVICE_URL", "http://nginx/api/products")
INTERNAL_API_KEY = os.getenv("INTERNAL_API_KEY")
if not INTERNAL_API_KEY:
    raise ValueError("INTERNAL_API_KEY environment variable is missing!")
breaker = pybreaker.CircuitBreaker(fail_max=3, reset_timeout=15)

def fetch_product(product_id: int, request_id: str, authorization: str = None):
    headers = {
        "X-Request-ID": request_id,
        "X-Internal-Secret": INTERNAL_API_KEY
    }
    if authorization:
        headers["Authorization"] = authorization
    try:
        response = httpx.get(f"{PRODUCT_SERVICE_URL}/{product_id}", headers=headers, timeout=5.0)
        response.raise_for_status()
        return response.json()
    except httpx.HTTPStatusError as e:
        if e.response.status_code == 404:
            raise HTTPException(status_code=404, detail=f"Product {product_id} not found")
        raise e
    except httpx.RequestError as e:
        raise Exception(f"Failed to communicate with Product Service: {str(e)}")

@breaker
def fetch_product_with_breaker(product_id: int, request_id: str, authorization: str = None):
    return fetch_product(product_id, request_id, authorization)


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

# Stage 2A Cart Schemas
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
    payment_method: str

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

# Routes
@app.post("/orders", response_model=OrderResponse)
def create_order(
    order_req: OrderCreate, 
    request: Request,
    db: Session = Depends(get_db), 
    user=Depends(get_current_user)
):
    request_id = request.headers.get("X-Request-ID", str(uuid.uuid4()))
    authorization = request.headers.get("Authorization")
    
    total_amount = 0.0
    items_to_create = []
    
    for item in order_req.items:
        try:
            product = fetch_product_with_breaker(item.product_id, request_id, authorization)
        except pybreaker.CircuitBreakerError:
            raise HTTPException(status_code=503, detail="Product service unavailable")
        except HTTPException as e:
            raise e
        except Exception as e:
            logger.error(f"Error fetching product: {e}")
            raise HTTPException(status_code=503, detail="Product service unavailable")
            
        if product["total_stock"] < item.quantity:
            raise HTTPException(status_code=400, detail=f"Insufficient stock for product {item.product_id}")
            
        unit_price = product["price"]
        total_amount += unit_price * item.quantity
        items_to_create.append({
            "product_id": item.product_id,
            "quantity": item.quantity,
            "unit_price": unit_price
        })
        
    new_order = Order(
        user_id=int(user["sub"]),
        status="Pending",
        total_amount=total_amount
    )
    db.add(new_order)
    db.commit()
    db.refresh(new_order)
    
    for item in items_to_create:
        order_item = OrderItem(
            order_id=new_order.order_id,
            product_id=item["product_id"],
            quantity=item["quantity"],
            unit_price=item["unit_price"]
        )
        db.add(order_item)
    
    db.commit()
    db.refresh(new_order)
    
    res_items = [
        OrderItemResponse(
            order_item_id=i.order_item_id,
            product_id=i.product_id,
            quantity=i.quantity,
            unit_price=float(i.unit_price)
        ) for i in new_order.items
    ]
    
    return OrderResponse(
        order_id=new_order.order_id,
        user_id=new_order.user_id,
        status=new_order.status,
        total_amount=float(new_order.total_amount),
        items=res_items
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

# Cart Routes
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

    cart = get_or_create_cart(db, user_id)
    
    # Deterministic behavior: adding existing product INCREASES its quantity
    existing_item = db.query(CartItemModel).filter(
        CartItemModel.cart_id == cart.cart_id,
        CartItemModel.product_id == item_in.product_id
    ).first()

    if existing_item:
        existing_item.quantity += item_in.quantity
    else:
        new_item = CartItemModel(
            cart_id=cart.cart_id,
            product_id=item_in.product_id,
            quantity=item_in.quantity
        )
        db.add(new_item)

    cart.updated_at = datetime.utcnow()
    db.commit()
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
    
    cart_item = db.query(CartItemModel).join(Cart).filter(
        CartItemModel.cart_item_id == item_id,
        Cart.user_id == user_id
    ).first()

    if not cart_item:
        raise HTTPException(status_code=404, detail="Cart item not found")

    cart_item.quantity = item_update.quantity
    cart_item.cart.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(cart_item.cart)
    return build_cart_response(cart_item.cart, request_id, authorization)

@app.delete("/cart/items/{item_id}")
def delete_cart_item(
    item_id: int,
    db: Session = Depends(get_db),
    user: dict = Depends(get_current_user)
):
    user_id = int(user["sub"])
    cart_item = db.query(CartItemModel).join(Cart).filter(
        CartItemModel.cart_item_id == item_id,
        Cart.user_id == user_id
    ).first()

    if not cart_item:
        raise HTTPException(status_code=404, detail="Cart item not found")

    cart = cart_item.cart
    db.delete(cart_item)
    cart.updated_at = datetime.utcnow()
    db.commit()
    return {"message": "Item removed from cart"}

@app.delete("/cart")
def empty_cart(
    db: Session = Depends(get_db),
    user: dict = Depends(get_current_user)
):
    user_id = int(user["sub"])
    cart = db.query(Cart).filter(Cart.user_id == user_id).first()
    if cart:
        db.query(CartItemModel).filter(CartItemModel.cart_id == cart.cart_id).delete()
        cart.updated_at = datetime.utcnow()
        db.commit()
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
