/*==========================================================
  SECTION 3: CUSTOMER ANALYSIS
  ==========================================================

 -- 3.1 New vs returning customers (monthly) */

 WITH customer_orders AS(
   SELECT 
     user_id,
     DATE_TRUNC(DATE(created_at), MONTH) AS month,
     ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS total_orders
   FROM bigquery-public-data.thelook_ecommerce.orders  
)
SELECT 
  month,
  COUNTIF(total_orders=1) AS new_customers,
  COUNTIF(total_orders>1) AS returning_customers
FROM customer_orders
GROUP BY month
ORDER BY month

-- 3.2 Top 5 customers by lifetime value
SELECT 
  u.id, 
  CONCAT(u.first_name, ' ', u.last_name) AS customer_name, 
  ROUND(SUM(oi.sale_price),2)AS lifetime_value
FROM bigquery-public-data.thelook_ecommerce.users AS u
JOIN bigquery-public-data.thelook_ecommerce.order_items AS oi
  ON u.id=oi.user_id
WHERE oi.status != 'Cancelled'
GROUP BY u.id, customer_name
ORDER BY lifetime_value DESC
LIMIT 5


  -- 3.3 Customer Segmentation Based on spend: 
        --Low(<$100)
        --Medium ($100–$500)
        --High (>$500)                                     
  
WITH total_spend AS(
  SELECT
    o.user_id, 
    ROUND(SUM(oi.sale_price),2)AS revenue
  FROM bigquery-public-data.thelook_ecommerce.orders AS o
  JOIN bigquery-public-data.thelook_ecommerce.order_items AS oi
    ON o.order_id=oi.order_id
  WHERE oi.status != 'Cancelled'
  GROUP BY o.user_id
)
segment AS (
SELECT 
  COUNT(user_id) AS total_customers,
  CASE 
      WHEN revenue < 100 THEN 'Low'
      WHEN revenue <= 500 THEN 'Medium'
      WHEN revenue > 500 THEN 'High'
      ELSE 'NULL'
  END AS segmented_customers
FROM total_spend
GROUP BY segmented_customers
ORDER BY total_customers;
)
SELECT
  ROUND(COUNTIF(segment = 'Low')   * 100.0 / COUNT(*), 2) AS low_percent,
  ROUND(COUNTIF(segment = 'Medium') * 100.0 / COUNT(*), 2) AS medium_percent,
  ROUND(COUNTIF(segment = 'High')  * 100.0 / COUNT(*), 2) AS high_percent
FROM segmented;
