/*
===============================================================================
Query Name  : Monthly Sales Trend (Last 12 Months)
===============================================================================
Objective:
- Analyze monthly sales trends over the past year
- Display current month sales and previous month sales

Business Definition:
- Sales represent gross sales (order demand)
- Includes all orders without filtering by order status

Time Window:
- Rolling 12 months based on the maximum order date in the dataset

Grain:
- One row per month
===============================================================================
*/

WITH max_order_date AS (
    SELECT
        MAX(order_date) AS max_order_date
    FROM orders
),

monthly_sales AS (
    SELECT
        DATETRUNC(month, fact_orders.order_date) AS sales_month,
        SUM(
            fact_order_items.quantity * fact_order_items.price_per_unit
        ) AS current_month_sales
    FROM orders AS fact_orders
    INNER JOIN order_items AS fact_order_items
        ON fact_orders.order_id = fact_order_items.order_id
    CROSS JOIN max_order_date m
    WHERE fact_orders.order_date BETWEEN
          DATEADD(YEAR, -1, m.max_order_date)
      AND m.max_order_date
    GROUP BY
        DATETRUNC(month, fact_orders.order_date)
)

SELECT
    sales_month,
    CAST(current_month_sales AS DECIMAL(12,2)) AS current_month_sales,
    CAST(
        LAG(current_month_sales) OVER (ORDER BY sales_month)
        AS DECIMAL(12,2)
    ) AS previous_month_sales
FROM monthly_sales
ORDER BY sales_month;
