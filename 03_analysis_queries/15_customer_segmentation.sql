/*
===============================================================================
Query Name  : Customer Return Behavior Classification
===============================================================================
Objective:
- Classify customers based on product return behavior

Business Definitions:
- Returned orders are identified using order_status = 'Returned'
- Customers with more than 5 returned orders are classified as 'High Return'
- Others are classified as 'Low Return'

Grain:
- One row per customer
===============================================================================
*/

WITH customer_order_stats AS (
    SELECT
        fact_orders.customer_id,
        COUNT(DISTINCT fact_orders.order_id) AS total_orders,
        SUM(
            CASE 
                WHEN fact_orders.order_status = 'Returned' THEN 1
                ELSE 0
            END
        ) AS returned_orders
    FROM orders AS fact_orders
    GROUP BY fact_orders.customer_id
)

SELECT
    dim_customers.customer_id,
    dim_customers.first_name,
    dim_customers.last_name,
    cos.total_orders,
    cos.returned_orders,
    CASE
        WHEN cos.returned_orders > 5 THEN 'high_return_customer'
        ELSE 'low_return_customer'
    END AS customer_category
FROM customer_order_stats cos
INNER JOIN customers AS dim_customers
    ON cos.customer_id = dim_customers.customer_id
ORDER BY cos.returned_orders DESC;
