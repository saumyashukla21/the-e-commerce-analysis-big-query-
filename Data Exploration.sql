/*==========================================================
  SECTION 1: DATA EXPLORATION
  ==========================================================*/
/* 1. Total number of:  
o Orders 
o Customers 
o Products 
2. Time range of data available 
3. Identify missing/null values in key fields */
  
/* Count Total orders*/
SELECT
    COUNT(DISTINCT order_id) AS total_orders
From bigquery-public-data.thelook_ecommerce.orders;
/* Count Total customers*/
SELECT 
    COUNT(DISTINCT id) AS total_customers
From bigquery-public-data.thelook_ecommerce.users; 
/* Count Total Products*/
SELECT 
    COUNT(DISTINCT id) AS total_products
From bigquery-public-data.thelook_ecommerce.products;

--1.2 Time range of Data available: Using the time when order is created
SELECT 
  DATE(MAX(created_at)) AS last_order,
  DATE(MIN(created_at)) AS first_order,
  DATE_DIFF(DATE(MAX(created_at)), DATE(MIN(created_at)), Month) AS month_diff,
  DATE_DIFF(DATE(MAX(created_at)), DATE(MIN(created_at)), Year) AS year_diff
FROM bigquery-public-data.thelook_ecommerce.orders; 


-- 1.3 Identify missing/null values in key fields
-- NOTE: Instead of analysing every column, analysed only those columns which will be used in grouping, filtering, aggregations, primary key, foreign key
SELECT 
-- Orders
    COUNTIF(order_id IS NULL) AS missing_order_id,
    COUNTIF(user_id IS NULL) AS missing_user_id,
    COUNTIF(status IS NULL) AS missing_status,
    COUNTIF(created_at IS NULL) AS missing_created_at,
    COUNTIF(returned_at IS NULL) AS missing_returned_at,
    COUNTIF(shipped_at IS NULL) AS missing_shipped_at,
    COUNTIF(delivered_at IS NULL) AS missing_delivered_at,
    COUNTIF(num_of_item IS NULL) AS missing_num_of_item
FROM bigquery-public-data.thelook_ecommerce.orders;

SELECT 
--Order_items Table
    COUNTIF(id IS NULL) AS missing_id,
    COUNTIF(order_id IS NULL) AS missing_order_id,
    COUNTIF(product_id IS NULL) AS missing_product_id,
    COUNTIF(created_at IS NULL) AS missing_created_at,
    COUNTIF(sale_price IS NULL) AS missing_sale_price
FROM bigquery-public-data.thelook_ecommerce.order_items;

SELECT 
--users table
    COUNTIF(id IS NULL) AS missing_id,
    COUNTIF(first_name IS NULL) AS missing_first_name,
    COUNTIF(last_name IS NULL) AS missing_last_name,
    COUNTIF(email IS NULL) AS missing_email,
    COUNTIF(age IS NULL) AS missing_age,
    COUNTIF(gender IS NULL) AS missing_gender,
    COUNTIF(state IS NULL) AS missing_state,
    COUNTIF(created_at IS NULL) AS missing_created_at
FROM bigquery-public-data.thelook_ecommerce.users;

SELECT 
--Products table
    COUNTIF(id IS NULL) AS missing_id,
    COUNTIF(cost IS NULL) AS missing_cost,
    COUNTIF(category IS NULL) AS missing_category,
    COUNTIF(name IS NULL) AS missing_name,
    COUNTIF(brand IS NULL) AS missing_brand,
    COUNTIF(retail_price IS NULL) AS missing_retail_price,
    COUNTIF(department IS NULL) AS missing_department
FROM bigquery-public-data.thelook_ecommerce.products;

SELECT 
--Inventory items
    COUNTIF(id IS NULL) AS missing_id,
    COUNTIF(created_at IS NULL) AS missing_created_at,
    COUNTIF(sold_at IS NULL) AS missing_sold_at,
    COUNTIF(cost IS NULL) AS missing_cost,
    COUNTIF(product_id IS NULL) AS missing_product_id
FROM bigquery-public-data.thelook_ecommerce.inventory_items;


