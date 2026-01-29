/*
===============================================================================
Query Name  : Product Profit Margin Ranking
===============================================================================
Objective:
- Calculate profit margin for each product
- Rank products from highest to lowest profit margin

Business Definitions:
- Revenue = quantity × price per unit
- Cost    = quantity × cost of goods sold (COGS)
- Profit  = Revenue − Cost
- Profit Margin (%) = Profit / Revenue × 100

Assumptions:
- Margin is calculated using gross sales (no order status filtering)
- COGS is stored at the product level

Grain:
- One row per product
===============================================================================
*/

WITH product_profit_metrics AS (
    SELECT
        dim_products.product_id,
        dim_products.product_name,
        SUM(fact_order_items.quantity * fact_order_items.price_per_unit)
            AS total_revenue,
        SUM(fact_order_items.quantity * dim_products.cogs)
            AS total_cost,
        SUM(
            fact_order_items.quantity * fact_order_items.price_per_unit
            - fact_order_items.quantity * dim_products.cogs
        ) AS total_profit
    FROM order_items AS fact_order_items
    INNER JOIN products AS dim_products
        ON fact_order_items.product_id = dim_products.product_id
    GROUP BY
        dim_products.product_id,
        dim_products.product_name
)

SELECT
    product_id,
    product_name,
    CAST(total_revenue AS DECIMAL(12,2)) AS total_revenue,
    CAST(total_cost AS DECIMAL(12,2)) AS total_cost,
    CAST(total_profit AS DECIMAL(12,2)) AS total_profit,
    CAST(
        total_profit * 100.0 / NULLIF(total_revenue, 0)
        AS DECIMAL(5,2)
    ) AS profit_margin_percentage,
    RANK() OVER (
        ORDER BY
            total_profit * 100.0 / NULLIF(total_revenue, 0) DESC
    ) AS profit_margin_rank
FROM product_profit_metrics
ORDER BY
    profit_margin_rank;
