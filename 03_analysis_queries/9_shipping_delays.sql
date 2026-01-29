/*
===============================================================================
Query Name  : Shipping Delays Analysis
===============================================================================
Objective:
- Identify orders where shipping occurred more than 3 days after order placement

Business Definition:
- A shipping delay is defined as shipping_date > order_date + 3 days
- Includes all orders with available shipping information
- No filtering on order status is applied

Grain:
- One row per order

Metrics:
- Days between order date and shipping date
===============================================================================
*/

SELECT
    fact_orders.order_id,
    fact_orders.order_date,
    dim_customers.customer_id,
    dim_customers.first_name,
    dim_customers.last_name,
    dim_customers.state,
    fact_shipping.shipping_provider,
    fact_shipping.shipping_date,
    DATEDIFF(
        DAY,
        fact_orders.order_date,
        fact_shipping.shipping_date
    ) AS shipping_delay_days
FROM orders AS fact_orders
INNER JOIN shipping AS fact_shipping
    ON fact_orders.order_id = fact_shipping.order_id
INNER JOIN customers AS dim_customers
    ON fact_orders.customer_id = dim_customers.customer_id
WHERE fact_shipping.shipping_date >
      DATEADD(DAY, 3, fact_orders.order_date)
ORDER BY
    shipping_delay_days DESC;
