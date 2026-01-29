/*
===============================================================================
Query Name  : Least Selling Product Category by State
===============================================================================
Objective:
- Identify the least-selling product category for each customer state

Business Definition:
- Sales represent gross sales (order demand)
- Includes all orders without filtering by order status

Grain:
- One row per state (least-selling category)

Tie Handling:
- If multiple categories have the same lowest sales within a state,
  all such categories are returned
===============================================================================
*/

WITH category_sales_by_state AS (
    SELECT
        dim_customers.state AS customer_state,
        dim_category.category_id,
        dim_category.category_name,
        SUM(
            fact_order_items.quantity * fact_order_items.price_per_unit
        ) AS total_sales_value
    FROM order_items AS fact_order_items
    INNER JOIN orders AS fact_orders
        ON fact_order_items.order_id = fact_orders.order_id
    INNER JOIN customers AS dim_customers
        ON fact_orders.customer_id = dim_customers.customer_id
    INNER JOIN products AS dim_products
        ON fact_order_items.product_id = dim_products.product_id
    INNER JOIN category AS dim_category
        ON dim_products.category_id = dim_category.category_id
    GROUP BY
        dim_customers.state,
        dim_category.category_id,
        dim_category.category_name
),

ranked_categories AS (
    SELECT
        customer_state,
        category_id,
        category_name,
        CAST(total_sales_value AS DECIMAL(12,2)) AS total_sales_value,
        RANK() OVER (
            PARTITION BY customer_state
            ORDER BY total_sales_value ASC
        ) AS category_rank_in_state
    FROM category_sales_by_state
)

SELECT
    customer_state AS state,
    category_name,
    total_sales_value
FROM ranked_categories
WHERE category_rank_in_state = 1
ORDER BY state;
