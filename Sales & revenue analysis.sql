/*==========================================================
  SECTION 2: SALES AND REVENUE ANALYSIS
  ==========================================================*/

-- 2.1 Monthly Revenue Trend
WITH monthly_revenue AS(
  SELECT
     DATE_TRUNC(DATE(o.created_at),MONTH) AS reporting_month,
     ROUND(SUM(oi.sale_price),2)AS revenue
  FROM bigquery-public-data.thelook_ecommerce.orders AS o
  JOIN bigquery-public-data.thelook_ecommerce.order_items AS oi
  ON o.order_id=oi.order_id
  WHERE o.status != 'Cancelled'
  GROUP BY reporting_month
  ORDER BY reporting_month
)
SELECT * 
FROM monthly_revenue

-- 2.2 Top 10 Products By Revenue
SELECT
  p.name, 
  SUM(oi.sale_price)AS revenue
FROM bigquery-public-data.thelook_ecommerce.products AS p
JOIN bigquery-public-data.thelook_ecommerce.order_items AS oi
  ON p.id=oi.product_id
JOIN bigquery-public-data.thelook_ecommerce.orders as o
  ON oi.order_id=o.order_id
WHERE o.status != 'Cancelled'
GROUP BY p.name
ORDER BY revenue DESC
LIMIT 10;

-- 2.3 Revenue by Product category
SELECT
  p.category,
  ROUND(SUM(oi.sale_price),2)AS revenue
FROM bigquery-public-data.thelook_ecommerce.products AS p
JOIN bigquery-public-data.thelook_ecommerce.order_items AS oi
 ON p.id=oi.product_id
JOIN bigquery-public-data.thelook_ecommerce.orders as o
  ON oi.order_id=o.order_id
WHERE o.status != 'Cancelled'
GROUP BY p.category
ORDER BY revenue DESC;

-- 2.4 Average order value(AOV)
WITH total_amount AS(
  SELECT 
    o.order_id, 
    SUM(sale_price)AS revenue
  FROM bigquery-public-data.thelook_ecommerce.order_items AS oi
  JOIN bigquery-public-data.thelook_ecommerce.orders as o
    ON oi.order_id=o.order_id
  WHERE o.status != 'Cancelled'
  GROUP BY o.order_id
)
SELECT 
  order_id,
  revenue,
  CASE 
    WHEN revenue < 100 THEN 'Low Value'
    WHEN revenue <= 500 THEN 'Medium Value'
    WHEN revenue > 500 THEN 'High Value'
    ELSE 'Null'
  END AS order_segmented,
  ROUND(AVG(revenue) over(),2) AS avg_order_value
  FROM total_amount
  ORDER BY order_segmented
