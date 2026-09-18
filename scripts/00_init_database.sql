/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, this script creates a schema called gold
	
WARNING:
    Running this script will drop the entire 'DataWarehouseAnalytics' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

-- Switch to the 'master' database so we are not connected to the database we're about to drop
USE master;
GO

-- Drop and recreate the 'DataWarehouseAnalytics' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouseAnalytics')
BEGIN
    -- Force the database into single-user mode and roll back any open transactions
    -- so the DROP below isn't blocked by other active connections
    ALTER DATABASE DataWarehouseAnalytics SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouseAnalytics;
END;
GO

-- Create the 'DataWarehouseAnalytics' database
CREATE DATABASE DataWarehouseAnalytics;
GO

-- Switch context into the newly created database before creating objects in it
USE DataWarehouseAnalytics;
GO

-- Create Schemas

-- 'gold' represents the final, business-ready layer of the warehouse
-- (as opposed to raw/staging "bronze" or cleaned "silver" layers used earlier in the pipeline)
CREATE SCHEMA gold;
GO

-- Dimension table: one row per customer
CREATE TABLE gold.dim_customers(
	customer_key int,          -- surrogate key used to join to fact_sales
	customer_id int,           -- natural/business key from the source system
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date           -- date the customer record was created
);
GO

-- Dimension table: one row per product
CREATE TABLE gold.dim_products(
	product_key int ,          -- surrogate key used to join to fact_sales
	product_id int ,           -- natural/business key from the source system
	product_number nvarchar(50) ,
	product_name nvarchar(50) ,
	category_id nvarchar(50) ,
	category nvarchar(50) ,
	subcategory nvarchar(50) ,
	maintenance nvarchar(50) ,
	cost int,
	product_line nvarchar(50),
	start_date date
);
GO

-- Fact table: one row per line item on a sales order
CREATE TABLE gold.fact_sales(
	order_number nvarchar(50),
	product_key int,           -- foreign key -> gold.dim_products.product_key
	customer_key int,          -- foreign key -> gold.dim_customers.customer_key
	order_date date,
	shipping_date date,
	due_date date,
	sales_amount int,
	quantity tinyint,
	price int
);
GO

-- Load dim_customers from CSV
-- NOTE: Update the file path below to match where you cloned/extracted the datasets locally.
TRUNCATE TABLE gold.dim_customers;
GO

BULK INSERT gold.dim_customers
FROM 'C:\Users\Shubham Mehla\Downloads\SQL-Data-Analytics-Project\datasets\flat-files\dim_customers.csv'
WITH (
	FIRSTROW = 2,          -- skip the header row
	FIELDTERMINATOR = ',', -- CSV columns are comma-separated
	TABLOCK                -- take a table-level lock for faster bulk loading
);
GO

-- Load dim_products from CSV
TRUNCATE TABLE gold.dim_products;
GO

BULK INSERT gold.dim_products
FROM 'C:\Users\Shubham Mehla\Downloads\SQL-Data-Analytics-Project\datasets\flat-files\dim_products.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

-- Load fact_sales from CSV
TRUNCATE TABLE gold.fact_sales;
GO

BULK INSERT gold.fact_sales
FROM 'C:\Users\Shubham Mehla\Downloads\SQL-Data-Analytics-Project\datasets\flat-files\fact_sales.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO
