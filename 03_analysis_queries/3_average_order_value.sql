/*
===============================================================================
Query Name  : Average Order Value (AOV) by Customer
===============================================================================
Objective:
- Calculate the average order value (AOV) for each customer
- Include only customers with more than 5 orders

Business Definition:
- AOV = Total order value / Number of distinct orders
- Order value is calculated as (quantity × price per unit)

Grain:
- One row per customer

Notes:
- This calculation uses gross sales (no order status filtering)
===============================================================================
*/

WITH order_values AS (
    SELECT
        fact_orders.order_id,
        fact_orders.customer_id,
        SUM(fact_order_items.quantity * fact_order_items.price_per_unit)
            AS order_total_value
    FROM orders AS fact_orders
    INNER JOIN order_items AS fact_order_items
        ON fact_orders.order_id = fact_order_items.order_id
    GROUP BY
        fact_orders.order_id,
        fact_orders.customer_id
),

customer_aov AS (
    SELECT
        customer_id,
        COUNT(order_id) AS total_orders,
        AVG(order_total_value) AS average_order_value
    FROM order_values
    GROUP BY customer_id
    HAVING COUNT(order_id) > 5
)

SELECT
    dim_customers.customer_id,
    dim_customers.first_name,
    dim_customers.last_name,
    CAST(customer_aov.average_order_value AS DECIMAL(12,2))
        AS average_order_value
FROM customer_aov
INNER JOIN customers AS dim_customers
    ON customer_aov.customer_id = dim_customers.customer_id
ORDER BY
    average_order_value DESC;
