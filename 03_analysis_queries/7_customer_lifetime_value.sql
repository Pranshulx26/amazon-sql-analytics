/*
===============================================================================
Query Name  : Customer Lifetime Value (CLTV) Ranking
===============================================================================
Objective:
- Calculate Customer Lifetime Value (CLTV) for each customer
- Rank customers based on their lifetime value

Business Definition:
- CLTV represents gross lifetime sales value
- Calculated as the sum of (quantity × price per unit)
- Includes all orders without filtering by order status

Grain:
- One row per customer

Ranking:
- Customers are ranked in descending order of CLTV
- Ties receive the same rank (RANK)
===============================================================================
*/

SELECT
    dim_customers.customer_id,
    dim_customers.first_name,
    dim_customers.last_name,
    CAST(
        SUM(fact_order_items.quantity * fact_order_items.price_per_unit)
        AS DECIMAL(12,2)
    ) AS customer_lifetime_value,
    RANK() OVER (
        ORDER BY
            SUM(fact_order_items.quantity * fact_order_items.price_per_unit) DESC
    ) AS customer_cltv_rank
FROM order_items AS fact_order_items
INNER JOIN orders AS fact_orders
    ON fact_order_items.order_id = fact_orders.order_id
INNER JOIN customers AS dim_customers
    ON fact_orders.customer_id = dim_customers.customer_id
GROUP BY
    dim_customers.customer_id,
    dim_customers.first_name,
    dim_customers.last_name
ORDER BY
    customer_cltv_rank;
