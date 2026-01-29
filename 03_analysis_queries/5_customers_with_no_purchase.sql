/*
===============================================================================
Query Name  : Customers with No Purchases
===============================================================================
Objective:
- Identify customers who have registered but never placed an order

Business Logic:
- Customers are considered inactive if no order exists for them
- LEFT JOIN is used to detect absence of orders

Limitation:
- Customer registration date is not available in the current schema
- Time since registration cannot be calculated without this column
===============================================================================
*/

SELECT
    dim_customers.customer_id,
    dim_customers.first_name,
    dim_customers.last_name,
    dim_customers.state
FROM customers AS dim_customers
LEFT JOIN orders AS fact_orders
    ON dim_customers.customer_id = fact_orders.customer_id
WHERE fact_orders.order_id IS NULL
ORDER BY dim_customers.customer_id;
