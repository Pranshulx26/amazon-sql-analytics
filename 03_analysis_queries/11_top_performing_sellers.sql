/*
===============================================================================
Query Name  : Top Performing Sellers (Sales & Order Success Rate)
===============================================================================
Objective:
- Identify the top 5 sellers based on total sales value
- Measure seller performance using order success rate

Business Definitions:
- Total Sales Value represents gross sales (order demand)
- Includes both successful and failed orders
- Successful orders are defined as order_status = 'Completed'

Grain:
- One row per seller

Metrics:
- Total sales value
- Total orders
- Completed orders
- Failed orders
- Percentage of successful orders
===============================================================================
*/

WITH top_sellers_by_sales AS (
    SELECT TOP 5
        dim_sellers.seller_id,
        dim_sellers.seller_name,
        CAST(
            SUM(fact_order_items.quantity * fact_order_items.price_per_unit)
            AS DECIMAL(12,2)
        ) AS total_sales_value
    FROM orders AS fact_orders
    INNER JOIN order_items AS fact_order_items
        ON fact_orders.order_id = fact_order_items.order_id
    INNER JOIN sellers AS dim_sellers
        ON fact_orders.seller_id = dim_sellers.seller_id
    GROUP BY
        dim_sellers.seller_id,
        dim_sellers.seller_name
    ORDER BY
        total_sales_value DESC
),

seller_order_statistics AS (
    SELECT
        ts.seller_id,
        ts.seller_name,
        COUNT(*) AS total_orders,
        SUM(
            CASE 
                WHEN fact_orders.order_status = 'Completed' THEN 1 
                ELSE 0 
            END
        ) AS completed_orders
    FROM orders AS fact_orders
    INNER JOIN top_sellers_by_sales ts
        ON fact_orders.seller_id = ts.seller_id
    GROUP BY
        ts.seller_id,
        ts.seller_name
)

SELECT
    seller_id,
    seller_name,
    completed_orders,
    total_orders - completed_orders AS failed_orders,
    total_orders,
    CAST(completed_orders * 100.0 / NULLIF(total_orders, 0) AS DECIMAL(5,2))
        AS successful_order_percentage
FROM seller_order_statistics
ORDER BY
    successful_order_percentage DESC;
