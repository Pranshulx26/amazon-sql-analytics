/*
===============================================================================
Query Name  : Inventory Stock Alerts
===============================================================================
Objective:
- Identify products with low inventory levels
- Support proactive restocking decisions

Business Definition:
- Products are flagged when stock levels fall below the alert threshold
- Inventory is evaluated per product per warehouse

Alert Threshold:
- Default threshold: stock < 10 units
- Can be adjusted based on business requirements

Grain:
- One row per product per warehouse
===============================================================================
*/

SELECT
    inv.inventory_id AS inventory_id,
    inv.product_id,
    dim_products.product_name,
    inv.warehouse_id,
    inv.stock AS current_stock,
    inv.last_stock_date AS last_restock_date
FROM inventory AS inv
INNER JOIN products AS dim_products
    ON inv.product_id = dim_products.product_id
WHERE inv.stock < 10
ORDER BY
    inv.stock ASC,
    inv.last_stock_date ASC;
