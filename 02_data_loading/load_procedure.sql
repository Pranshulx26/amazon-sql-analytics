/*
================================================================
Stored Procedure: Load Amazon Project Tables
================================================================
Purpose:
- Truncates Amazon project tables (Child → Parent)
- Loads data from CSV files (Parent → Child)
- Logs execution time per table
- Uses TRY / CATCH for error handling

Usage:
  EXEC dbo.load_amazon_data;
================================================================
*/

CREATE OR ALTER PROCEDURE dbo.load_amazon_data
AS
BEGIN
    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @layer_start_time DATETIME,
        @layer_end_time DATETIME;

    BEGIN TRY

        SET @layer_start_time = GETDATE();

        PRINT '=========================================================';
        PRINT 'Starting Amazon Data Load';
        PRINT '=========================================================';

        ---------------------------------------------------------
        -- CLEAN TABLES (SQL SERVER SAFE WAY)
        ---------------------------------------------------------
        PRINT '>> Cleaning tables (TRUNCATE where allowed, DELETE where required)';

        -- CHILD TABLES → TRUNCATE OK
        TRUNCATE TABLE shipping;
        TRUNCATE TABLE payments;
        TRUNCATE TABLE order_items;
        TRUNCATE TABLE inventory;

        -- PARENT TABLES → DELETE REQUIRED
        DELETE FROM orders;
        DELETE FROM products;
        DELETE FROM customers;
        DELETE FROM sellers;
        DELETE FROM category;

        PRINT '>> Table cleanup completed';
        PRINT '---------------------------------------------------------';

        ---------------------------------------------------------
        -- LOAD CATEGORY
        ---------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Loading: category';

        BULK INSERT category
        FROM 'C:\Users\yashs\Desktop\amazon-sql\data\category.csv'
        WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR);
        PRINT '---------------------------------------------------------';

        ---------------------------------------------------------
        -- LOAD CUSTOMERS
        ---------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Loading: customers';

        BULK INSERT customers
        FROM 'C:\Users\yashs\Desktop\amazon-sql\data\customers.csv'
        WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR);
        PRINT '---------------------------------------------------------';

        ---------------------------------------------------------
        -- LOAD SELLERS
        ---------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Loading: sellers';

        BULK INSERT sellers
        FROM 'C:\Users\yashs\Desktop\amazon-sql\data\sellers.csv'
        WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR);
        PRINT '---------------------------------------------------------';

        ---------------------------------------------------------
        -- LOAD PRODUCTS
        ---------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Loading: products';

        BULK INSERT products
        FROM 'C:\Users\yashs\Desktop\amazon-sql\data\products.csv'
        WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR);
        PRINT '---------------------------------------------------------';

        ---------------------------------------------------------
        -- LOAD ORDERS
        ---------------------------------------------------------
        SET @start_time = GETDATE();
        PRINT '>> Loading: orders';

        BULK INSERT orders
        FROM 'C:\Users\yashs\Desktop\amazon-sql\data\orders.csv'
        WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

        SET @end_time = GETDATE();
        PRINT '>> Duration: ' + CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR);
        PRINT '---------------------------------------------------------';

        ---------------------------------------------------------
        -- LOAD ORDER ITEMS
        ---------------------------------------------------------
        BULK INSERT order_items
        FROM 'C:\Users\yashs\Desktop\amazon-sql\data\order_items.csv'
        WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

        ---------------------------------------------------------
        -- LOAD PAYMENTS
        ---------------------------------------------------------
        BULK INSERT payments
        FROM 'C:\Users\yashs\Desktop\amazon-sql\data\payments.csv'
        WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

        ---------------------------------------------------------
        -- LOAD SHIPPING
        ---------------------------------------------------------
        BULK INSERT shipping
        FROM 'C:\Users\yashs\Desktop\amazon-sql\data\shipping.csv'
        WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

        ---------------------------------------------------------
        -- LOAD INVENTORY
        ---------------------------------------------------------
        BULK INSERT inventory
        FROM 'C:\Users\yashs\Desktop\amazon-sql\data\inventory.csv'
        WITH ( FIRSTROW = 2, FIELDTERMINATOR = ',', TABLOCK );

        SET @layer_end_time = GETDATE();

        PRINT '=========================================================';
        PRINT 'Amazon Data Load Completed Successfully';
        PRINT 'Total Execution Time: ' 
              + CAST(DATEDIFF(SECOND,@layer_start_time,@layer_end_time) AS NVARCHAR)
              + ' seconds';
        PRINT '=========================================================';

    END TRY
    BEGIN CATCH
        PRINT '=========================================================';
        PRINT 'ERROR OCCURRED DURING AMAZON DATA LOAD';
        PRINT ERROR_MESSAGE();
        PRINT '=========================================================';
    END CATCH
END;
GO

