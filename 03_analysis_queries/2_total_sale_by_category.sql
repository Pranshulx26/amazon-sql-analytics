/*
===============================================================================
Query Name  : Total Sales by Category (Percentage Contribution)
===============================================================================
Objective:
- Calculate total sales value for each product category
- Determine each category's percentage contribution to overall sales

Business Definition:
- Total Sales Value represents gross sales (order demand)
- Includes all orders without filtering by order status

Grain:
- One row per product category

Metrics:
- Total sales value
- Percentage contribution to total sales
===============================================================================
*/
WITH category_sales AS (
    SELECT
        dim_category.category_id,
        dim_category.category_name,
        SUM(fact_order_items.quantity * fact_order_items.price_per_unit)
            AS category_sales_value
    FROM order_items AS fact_order_items
    INNER JOIN products AS dim_products
        ON fact_order_items.product_id = dim_products.product_id
    INNER JOIN category AS dim_category
        ON dim_products.category_id = dim_category.category_id
    GROUP BY
        dim_category.category_id,
        dim_category.category_name
),

total_sales AS (
    SELECT
        SUM(category_sales_value) AS overall_sales_value
    FROM category_sales
)

SELECT
    cs.category_id,
    cs.category_name,
    CAST(cs.category_sales_value AS DECIMAL(12,2)) AS category_sales_value,
    CAST(
        cs.category_sales_value * 100.0 / ts.overall_sales_value
        AS DECIMAL(5,2)
    ) AS sales_percentage_contribution
FROM category_sales cs
CROSS JOIN total_sales ts
ORDER BY
    sales_percentage_contribution DESC;
