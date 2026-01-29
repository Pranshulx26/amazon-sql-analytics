/*
===============================================================================
Query Name  : Top Selling Products (Gross Sales)
===============================================================================
Objective:
- Identify the top 10 products based on total sales value

Business Definition:
- Total Sales Value represents gross sales (order demand)
- Includes all orders regardless of order status

Grain:
- One row per product

Metrics:
- Total quantity sold
- Total sales value (quantity × price per unit)

Notes:
- If revenue (realized sales) is required, apply appropriate
  order status / payment filters.
===============================================================================
*/

USE amazon_db;

SELECT TOP 10
    dim_products.product_id,
    dim_products.product_name,
    SUM(fact_order_items.quantity) AS total_quantity_sold,
    CAST(
        SUM(fact_order_items.quantity * fact_order_items.price_per_unit)
        AS DECIMAL(12,2)
    ) AS total_sales_value
FROM order_items AS fact_order_items
INNER JOIN products AS dim_products
    ON fact_order_items.product_id = dim_products.product_id
INNER JOIN orders AS fact_orders
    ON fact_order_items.order_id = fact_orders.order_id
GROUP BY
    dim_products.product_id,
    dim_products.product_name
ORDER BY
    total_sales_value DESC;
