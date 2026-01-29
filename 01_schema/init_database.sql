/*

======================================================
Create Database and Schemas
======================================================
Script Purpose:
  This script creates a new database named 'amazon_db' after checking if it already exists.
  If the database exists, it is dropeed and recreated.

WARNING:
  Running this script will drop the entire  'amazon_db' database if it exists.
  All data in the database will be permanently deleted. Proceed with caution
  and ensure you have proper backups before running this script.
*/


-- Create Database 'amazon_db'
USE master; 
GO

-- Drop and recreate the 'amazon_db' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'amazon_db')
BEGIN 
    ALTER DATABASE amazon_db SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE amazon_db;
END;
GO

-- Create the 'amazon_db' database
CREATE DATABASE amazon_db;
GO
  
USE amazon_db;
GO
