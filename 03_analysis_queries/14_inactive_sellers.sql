/*
===============================================================================
Query Name  : Inactive Sellers Analysis
===============================================================================
Objective:
- Identify sellers with no sales in the last 6 months
- Display their last sale date and total historical sales

Business Definitions:
- Inactivity is defined relative to the maximum order date in the dataset
- Sales represent gross sales (quantity × price per unit)

Grain:
- One row per seller
===============================================================================
*/

WITH max_order_date AS (
    SELECT MAX(order_date) AS max_order_date
    FROM orders
),

seller_sales AS (
    SELECT
        fact_orders.seller_id,
        MAX(fact_orders.order_date) AS last_sale_date,
        SUM(fact_order_items.quantity * fact_order_items.price_per_unit)
            AS total_sales_value
    FROM orders AS fact_orders
    INNER JOIN order_items AS fact_order_items
        ON fact_orders.order_id = fact_order_items.order_id
    GROUP BY fact_orders.seller_id
)

SELECT
    dim_sellers.seller_id,
    dim_sellers.seller_name,
    ss.last_sale_date,
    CAST(ss.total_sales_value AS DECIMAL(12,2)) AS total_sales_value
FROM sellers AS dim_sellers
LEFT JOIN seller_sales ss
    ON dim_sellers.seller_id = ss.seller_id
CROSS JOIN max_order_date m
WHERE ss.last_sale_date < DATEADD(MONTH, -6, m.max_order_date)
   OR ss.last_sale_date IS NULL
ORDER BY ss.last_sale_date;
