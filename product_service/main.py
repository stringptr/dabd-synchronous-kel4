import os
import uuid
import logging
from datetime import datetime
from typing import Optional, List

from fastapi import FastAPI, Depends, HTTPException, status, Request, Response, Header
from pydantic import BaseModel, Field
from sqlalchemy import create_engine, Column, Integer, String, Float, DateTime, ForeignKey, text, Numeric
from sqlalchemy.orm import sessionmaker, declarative_base, Session, relationship

# Logging setup
logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger("product_service")

# Database setup
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "postgres")
DB_NAME = os.getenv("DB_NAME", "postgres")
DB_PORT = os.getenv("DB_PORT", "5432")
DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

class Product(Base):
    __tablename__ = "products"
    product_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(200), nullable=False)
    description = Column(String)
    price = Column(Numeric(10, 2), nullable=False)
    cost = Column(Numeric(10, 2))
    category_id = Column(Integer)
    supplier_id = Column(Integer)
    created_at = Column(DateTime, default=datetime.utcnow)
    
    inventory = relationship("Inventory", back_populates="product")

class Inventory(Base):
    __tablename__ = "inventory"
    product_id = Column(Integer, ForeignKey("products.product_id"), primary_key=True)
    warehouse_id = Column(Integer, primary_key=True)
    quantity_on_hand = Column(Integer, nullable=False, default=0)
    
    product = relationship("Product", back_populates="inventory")

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
    name: str = Field(..., min_length=1)
    description: Optional[str] = None
    price: float = Field(..., gt=0)
    category_id: Optional[int] = None
    supplier_id: Optional[int] = None

class ProductResponse(BaseModel):
    product_id: int
    name: str
    description: Optional[str]
    price: float
    category_id: Optional[int]
    supplier_id: Optional[int]
    total_stock: int

def require_admin(x_user_role: Optional[str] = Header(None)):
    if x_user_role != "admin":
        raise HTTPException(status_code=403, detail="Forbidden: Admin access required")
    return True

# Routes
@app.get("/products", response_model=List[ProductResponse])
def get_products(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    products = db.query(Product).offset(skip).limit(limit).all()
    res = []
    for p in products:
        total_stock = sum(inv.quantity_on_hand for inv in p.inventory) if p.inventory else 0
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
    total_stock = sum(inv.quantity_on_hand for inv in p.inventory) if p.inventory else 0
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
