-- 1. Users and Admins
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(30),
    address_line VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Admins (
    user_id INT REFERENCES Users(user_id)
);

-- 2. Categories (hierarchical)
CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    parent_category_id INT REFERENCES Categories(category_id)
);

-- 3. Suppliers
CREATE TABLE Suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    address TEXT
);

-- 4. Products
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    cost DECIMAL(10,2) CHECK (cost >= 0),
    category_id INT REFERENCES Categories(category_id),
    supplier_id INT REFERENCES Suppliers(supplier_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Warehouses
CREATE TABLE Warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(20)
);

-- 6. Inventory (Junction Table)
CREATE TABLE Inventory (
    product_id INT REFERENCES Products(product_id) ON DELETE CASCADE,
    warehouse_id INT REFERENCES Warehouses(warehouse_id) ON DELETE CASCADE,
    quantity_on_hand INT NOT NULL DEFAULT 0,
    reorder_level INT DEFAULT 10,
    PRIMARY KEY (product_id, warehouse_id)
);

-- 7. Coupons
CREATE TABLE Coupons (
    coupon_id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    description VARCHAR(255),
    discount_type VARCHAR(20) CHECK (discount_type IN ('Percentage', 'Fixed')) NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL CHECK (discount_value >= 0),
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    usage_limit INT
);

-- 8. Orders
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) NOT NULL,
    coupon_id INT REFERENCES Coupons(coupon_id) NULL, -- optional discount
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Paid', 'Shipped', 'Delivered', 'Cancelled')) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0)
);

-- 9. Order_Items
CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE NOT NULL,
    product_id INT REFERENCES Products(product_id) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    discount DECIMAL(5,2) DEFAULT 0.00 CHECK (discount >= 0)
);

-- 10. Payments
CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) UNIQUE NOT NULL, -- 1:1 relationship
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
    method VARCHAR(20) CHECK (method IN ('Credit Card', 'PayPal', 'Bank Transfer', 'Gift Card')) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Completed', 'Failed')) NOT NULL
);

-- 11. Shipments
CREATE TABLE Shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) UNIQUE NOT NULL, -- 1:1 usually
    warehouse_id INT REFERENCES Warehouses(warehouse_id) NOT NULL,
    carrier VARCHAR(50),
    tracking_number VARCHAR(100),
    shipped_date TIMESTAMP,
    delivered_date TIMESTAMP,
    CHECK (delivered_date IS NULL OR shipped_date IS NOT NULL) -- cannot deliver before ship
);

-- 12. Reviews
CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES Products(product_id) ON DELETE CASCADE NOT NULL,
    user_id INT REFERENCES Users(user_id) ON DELETE CASCADE NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5) NOT NULL,
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (product_id, user_id) -- prevent duplicate reviews
);
