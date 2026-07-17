/*==========================================================
  SECTION 4: OPERATIONAL INSIGHTS
  ==========================================================*/

-- 4.1 Order fulfillment time (order → delivered)
SELECT 
  ROUND(AVG(DATE_DIFF(DATE(delivered_at), DATE(created_at), DAY)),2) AS order_fulfillment_time
FROM bigquery-public-data.thelook_ecommerce.orders 
WHERE delivered_at IS NOT NULL;

-- 4.2 Cancellation/return rate 
SELECT 
  ROUND(COUNTIF(status = 'Cancelled')*100/ COUNT(*), 2) AS cancellation_rate_percentage,
  ROUND(COUNTIF(status = 'Returned')*100/ COUNT(*),2) AS return_rate_percentage
FROM bigquery-public-data.thelook_ecommerce.orders 

-- 4.3 Inventory vs sales mismatch (overstock/understock)
WITH inventory AS (
  SELECT
   product_id,
   COUNT(*) AS stock
  FROM bigquery-public-data.thelook_ecommerce.inventory_items
  GROUP BY product_id
),
sales AS (
  SELECT 
   product_id,
   COUNT(*) AS sold
  FROM bigquery-public-data.thelook_ecommerce.order_items
  WHERE status!= 'Cancelled'
  GROUP BY product_id 
)
SELECT 
  p.name as product_name,
  COALESCE(i.stock,0) AS stock,
  COALESCE(s.sold,0) AS sold,
  COALESCE(i.stock,0) - COALESCE(s.sold,0) AS inventory_gap,
  CASE
    WHEN COALESCE(i.stock,0) - COALESCE(s.sold,0) > 0 THEN 'Overstock'
    WHEN COALESCE(i.stock,0) - COALESCE(s.sold,0) < 0 THEN 'Understock'
    ELSE 'Balanced'
  END AS mismatch
FROM bigquery-public-data.thelook_ecommerce.products AS p
LEFT JOIN inventory AS i
  ON p.id=i.product_id
LEFT JOIN sales AS s
  ON p.id=s.product_id
ORDER BY inventory_gap;
