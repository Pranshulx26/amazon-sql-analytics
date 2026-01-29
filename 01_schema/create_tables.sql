/*
================================================================
DDL Script: Amazon Data Analysis Project (SQL Server)
================================================================
Purpose:
- Drops existing tables safely (FK-aware)
- Creates normalized OLTP-style tables
- Uses SQL Server best practices
================================================================
*/

------------------------------------------------------------
-- DROP TABLES (Child → Parent Order)
------------------------------------------------------------

IF OBJECT_ID('shipping', 'U') IS NOT NULL DROP TABLE shipping;
IF OBJECT_ID('payments', 'U') IS NOT NULL DROP TABLE payments;
IF OBJECT_ID('order_items', 'U') IS NOT NULL DROP TABLE order_items;
IF OBJECT_ID('inventory', 'U') IS NOT NULL DROP TABLE inventory;
IF OBJECT_ID('orders', 'U') IS NOT NULL DROP TABLE orders;
IF OBJECT_ID('products', 'U') IS NOT NULL DROP TABLE products;
IF OBJECT_ID('customers', 'U') IS NOT NULL DROP TABLE customers;
IF OBJECT_ID('sellers', 'U') IS NOT NULL DROP TABLE sellers;
IF OBJECT_ID('category', 'U') IS NOT NULL DROP TABLE category;
GO

------------------------------------------------------------
-- CATEGORY
------------------------------------------------------------
CREATE TABLE category (
    category_id   INT PRIMARY KEY,
    category_name NVARCHAR(20) NOT NULL
);
GO

------------------------------------------------------------
-- CUSTOMERS
------------------------------------------------------------
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name  NVARCHAR(20) NOT NULL,
    last_name   NVARCHAR(20),
    state       NVARCHAR(20)
);
GO

------------------------------------------------------------
-- SELLERS
------------------------------------------------------------
CREATE TABLE sellers (
    seller_id   INT PRIMARY KEY,
    seller_name NVARCHAR(30) NOT NULL,
    origin      NVARCHAR(10)
);
GO

------------------------------------------------------------
-- PRODUCTS
------------------------------------------------------------
CREATE TABLE products (
    product_id   INT PRIMARY KEY,
    product_name NVARCHAR(50) NOT NULL,
    price        DECIMAL(10,2) NOT NULL,
    cogs         DECIMAL(10,2) NOT NULL,
    category_id  INT NOT NULL,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id)
        REFERENCES category(category_id)
);
GO

------------------------------------------------------------
-- ORDERS
------------------------------------------------------------
CREATE TABLE orders (
    order_id     INT PRIMARY KEY,
    order_date   DATE NOT NULL,
    customer_id  INT NOT NULL,
    seller_id    INT NOT NULL,
    order_status NVARCHAR(20),

    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_orders_sellers
        FOREIGN KEY (seller_id)
        REFERENCES sellers(seller_id)
);
GO

------------------------------------------------------------
-- ORDER ITEMS
------------------------------------------------------------
CREATE TABLE order_items (
    order_item_id  INT PRIMARY KEY,
    order_id       INT NOT NULL,
    product_id     INT NOT NULL,
    quantity       INT NOT NULL,
    price_per_unit DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
GO

------------------------------------------------------------
-- PAYMENTS
------------------------------------------------------------
CREATE TABLE payments (
    payment_id     INT PRIMARY KEY,
    order_id       INT NOT NULL,
    payment_date   DATE NOT NULL,
    payment_status NVARCHAR(20),

    CONSTRAINT fk_payments_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);
GO

------------------------------------------------------------
-- SHIPPING
------------------------------------------------------------
CREATE TABLE shipping (
    shipping_id        INT PRIMARY KEY,
    order_id           INT NOT NULL,
    shipping_date      DATE,
    return_date        DATE,
    shipping_provider  NVARCHAR(20),
    delivery_status    NVARCHAR(20),

    CONSTRAINT fk_shipping_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);
GO

------------------------------------------------------------
-- INVENTORY
------------------------------------------------------------
CREATE TABLE inventory (
    inventory_id   INT PRIMARY KEY,
    product_id     INT NOT NULL,
    stock          INT NOT NULL,
    warehouse_id   INT,
    last_stock_date DATE,

    CONSTRAINT fk_inventory_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);
GO
