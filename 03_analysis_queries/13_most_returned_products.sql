/*
===============================================================================
Query Name  : Most Returned Products
===============================================================================
Objective:
- Identify the top 10 products by number of returned units
- Calculate return rate as a percentage of total units sold

Business Definitions:
- Total Units Sold = Sum of quantities sold per product
- Returned Units   = Sum of quantities for orders marked as 'Returned'
- Return Rate (%)  = Returned Units / Total Units Sold × 100

Assumptions:
- Order-level status 'Returned' indicates all items in the order were returned
- Analysis is based on gross sales (no date filtering applied)

Grain:
- One row per product
===============================================================================
*/

SELECT TOP 10
    dim_products.product_id,
    dim_products.product_name,
    SUM(fact_order_items.quantity) AS total_units_sold,
    SUM(
        CASE 
            WHEN fact_orders.order_status = 'Returned'
            THEN fact_order_items.quantity
            ELSE 0
        END
    ) AS returned_units,
    CAST(
        SUM(
            CASE 
                WHEN fact_orders.order_status = 'Returned'
                THEN fact_order_items.quantity
                ELSE 0
            END
        ) * 100.0
        / NULLIF(SUM(fact_order_items.quantity), 0)
        AS DECIMAL(5,2)
    ) AS return_rate_percentage
FROM orders AS fact_orders
INNER JOIN order_items AS fact_order_items
    ON fact_orders.order_id = fact_order_items.order_id
INNER JOIN products AS dim_products
    ON fact_order_items.product_id = dim_products.product_id
GROUP BY
    dim_products.product_id,
    dim_products.product_name
ORDER BY
    returned_units DESC;
