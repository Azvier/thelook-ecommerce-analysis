-- 04_analytical_queries.sql

-- 1. List all tables in the database (schema overview)
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

-- 2. Overall business summary: total sales, orders, and customers
SELECT 
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT u.id) AS total_customers,
    SUM(oi.sale_price) AS total_sales
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN order_items oi ON o.order_id = oi.order_id;

-- 3. Monthly sales trend (revenue over time)
SELECT 
    DATE_TRUNC('month', o.created_at) AS month,
    SUM(oi.sale_price) AS monthly_sales
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- 4. New users by month (user acquisition trend)
SELECT 
    DATE_TRUNC('month', created_at) AS cohort_month,
    COUNT(*) AS new_users
FROM users
GROUP BY cohort_month
ORDER BY cohort_month;

-- 5. Average order value (AOV) by month
SELECT 
    DATE_TRUNC('month', o.created_at) AS month,
    SUM(oi.sale_price) / NULLIF(COUNT(DISTINCT o.order_id), 0) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- 6. Order status distribution (completed, returned, etc.)
SELECT
    o.status,
    COUNT(*) AS num_orders,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders) AS percentage
FROM orders o
GROUP BY o.status
ORDER BY num_orders DESC;

-- 7. Customer segmentation: repeat vs. one-time customers
SELECT 
    CASE WHEN order_count = 1 THEN 'One-time' ELSE 'Repeat' END AS customer_type,
    COUNT(*) AS num_customers
FROM (
    SELECT user_id, COUNT(*) AS order_count
    FROM orders
    GROUP BY user_id
) t
GROUP BY customer_type;

-- 8. Customer order statistics by state
SELECT
    u.state,
    COUNT(DISTINCT u.id) AS num_customers,
    COUNT(DISTINCT o.order_id) AS num_orders,
    COUNT(DISTINCT o.order_id)::FLOAT / COUNT(DISTINCT u.id) AS orders_per_customer,
    SUM(oi.sale_price) AS total_revenue,
    SUM(oi.sale_price) / COUNT(DISTINCT u.id) AS revenue_per_customer
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.state
ORDER BY total_revenue DESC NULLS LAST
LIMIT 20;

-- 9. User demographics analysis (age group, gender, orders, revenue)
SELECT
    CASE
        WHEN u.age < 18 THEN 'Under 18'
        WHEN u.age BETWEEN 18 AND 24 THEN '18-24'
        WHEN u.age BETWEEN 25 AND 34 THEN '25-34'
        WHEN u.age BETWEEN 35 AND 44 THEN '35-44'
        WHEN u.age BETWEEN 45 AND 54 THEN '45-54'
        WHEN u.age BETWEEN 55 AND 64 THEN '55-64'
        WHEN u.age >= 65 THEN '65+'
        ELSE 'Unknown'
    END AS age_group,
    u.gender,
    COUNT(*) AS num_users,
    COUNT(DISTINCT o.order_id) AS num_orders,
    SUM(oi.sale_price) AS total_revenue
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY age_group, u.gender
ORDER BY age_group, u.gender;

-- 10. Top 10 best-selling products
SELECT 
    p.name AS product_name,
    COUNT(oi.id) AS total_items_sold,
    SUM(oi.sale_price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.name
ORDER BY total_items_sold DESC
LIMIT 10;

-- 11. Product category performance
SELECT 
    p.category,
    SUM(oi.sale_price) AS total_sales,
    COUNT(oi.id) AS total_items_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.category
ORDER BY total_sales DESC;

-- 12. Product analysis by department and brand
SELECT
    p.department,
    p.brand,
    COUNT(DISTINCT p.id) AS num_products,
    COUNT(oi.id) AS num_sales,
    SUM(oi.sale_price) AS total_revenue,
    SUM(oi.sale_price) / COUNT(oi.id) AS avg_price
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.department, p.brand
ORDER BY total_revenue DESC NULLS LAST
LIMIT 20;

-- 13. Inventory count by distribution center (capacity/utilization)
SELECT 
    d.name AS distribution_center,
    COUNT(i.id) AS inventory_items_count
FROM inventory_items i
JOIN distribution_centers d ON i.product_distribution_center_id = d.id
GROUP BY d.name
ORDER BY inventory_items_count DESC;

-- 14. Customer lifetime value (CLV) for top 10 customers
SELECT 
    u.id AS user_id,
    u.first_name,
    u.last_name,
    SUM(oi.sale_price) AS lifetime_value
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.id, u.first_name, u.last_name
ORDER BY lifetime_value DESC
LIMIT 10;

-- 15. Top 10 customers by number of orders
SELECT 
    u.id AS user_id,
    u.first_name,
    u.last_name,
    COUNT(DISTINCT o.order_id) AS num_orders
FROM users u
JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.first_name, u.last_name
ORDER BY num_orders DESC
LIMIT 10;

-- 16. Traffic source analysis for user acquisition
SELECT
    u.traffic_source,
    COUNT(DISTINCT u.id) AS num_users,
    COUNT(DISTINCT o.order_id) AS num_orders,
    SUM(oi.sale_price) AS total_revenue,
    SUM(oi.sale_price) / COUNT(DISTINCT u.id) AS revenue_per_user
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY u.traffic_source
ORDER BY num_users DESC;

-- 17. Conversion rate by traffic source
SELECT 
    u.traffic_source,
    COUNT(DISTINCT u.id) AS num_users,
    COUNT(DISTINCT o.user_id) AS num_buyers,
    ROUND(COUNT(DISTINCT o.user_id) * 100.0 / NULLIF(COUNT(DISTINCT u.id),0), 2) AS conversion_rate_percent
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.traffic_source
ORDER BY conversion_rate_percent DESC, num_users DESC;

-- 18. Sales by traffic source over time (monthly)
SELECT 
    DATE_TRUNC('month', o.created_at) AS month,
    u.traffic_source,
    SUM(oi.sale_price) AS total_sales
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month, u.traffic_source
ORDER BY month, total_sales DESC;

-- 19. Customer retention rate by cohort (first order month)
WITH first_orders AS (
    SELECT user_id, MIN(DATE_TRUNC('month', created_at)) AS cohort_month
    FROM orders
    GROUP BY user_id
),
orders_by_month AS (
    SELECT user_id, DATE_TRUNC('month', created_at) AS order_month
    FROM orders
)
SELECT 
    f.cohort_month,
    o.order_month,
    COUNT(DISTINCT o.user_id) AS num_users,
    ROUND(COUNT(DISTINCT o.user_id) * 100.0 /
        (SELECT COUNT(*) FROM first_orders f2 WHERE f2.cohort_month = f.cohort_month), 2) AS retention_rate
FROM first_orders f
JOIN orders_by_month o ON f.user_id = o.user_id
WHERE o.order_month >= f.cohort_month
GROUP BY f.cohort_month, o.order_month
ORDER BY f.cohort_month, o.order_month
LIMIT 20;

-- 20. Time to first purchase for new users
SELECT 
    u.id AS user_id,
    u.first_name,
    u.created_at AS registration_date,
    MIN(o.created_at) AS first_order_date,
    EXTRACT(DAY FROM MIN(o.created_at) - u.created_at) AS days_to_first_purchase
FROM users u
JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.first_name, u.created_at
ORDER BY days_to_first_purchase DESC
LIMIT 20;

-- 21. Churned customers (no orders in last 3 months)
SELECT 
    u.id AS user_id,
    u.first_name,
    u.last_name,
    MAX(o.created_at) AS last_order_date
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.first_name, u.last_name
HAVING MAX(o.created_at) < (CURRENT_DATE - INTERVAL '3 months') OR MAX(o.created_at) IS NULL
ORDER BY last_order_date
LIMIT 20;

-- 22. Product return rate (top 20 products)
SELECT 
    p.name AS product_name,
    COUNT(oi.id) FILTER (WHERE oi.returned_at IS NOT NULL) AS num_returned,
    COUNT(oi.id) AS total_sold,
    ROUND(COUNT(oi.id) FILTER (WHERE oi.returned_at IS NOT NULL) * 100.0 / NULLIF(COUNT(oi.id),0), 2) AS return_rate_percent
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.name
ORDER BY return_rate_percent DESC, total_sold DESC
LIMIT 20;

-- 23. Average shipping and delivery time by product brand
SELECT
    p.brand,
    COUNT(DISTINCT o.order_id) AS num_orders,
    ROUND(AVG(EXTRACT(EPOCH FROM (o.shipped_at - o.created_at))/3600), 2) AS avg_hours_to_ship,
    ROUND(AVG(EXTRACT(EPOCH FROM (o.delivered_at - o.shipped_at))/3600), 2) AS avg_hours_to_deliver,
    ROUND(AVG(EXTRACT(EPOCH FROM (o.delivered_at - o.created_at))/3600), 2) AS avg_total_fulfillment_hours
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.shipped_at IS NOT NULL AND o.delivered_at IS NOT NULL
GROUP BY p.brand
ORDER BY avg_total_fulfillment_hours DESC;

-- 24. Average shipping and delivery time by distribution center
SELECT
    d.name AS distribution_center,
    COUNT(DISTINCT o.order_id) AS num_orders,
    ROUND(AVG(EXTRACT(EPOCH FROM (o.shipped_at - o.created_at))/3600), 2) AS avg_hours_to_ship,
    ROUND(AVG(EXTRACT(EPOCH FROM (o.delivered_at - o.shipped_at))/3600), 2) AS avg_hours_to_deliver,
    ROUND(AVG(EXTRACT(EPOCH FROM (o.delivered_at - o.created_at))/3600), 2) AS avg_total_fulfillment_hours
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN inventory_items ii ON oi.inventory_item_id = ii.id
JOIN distribution_centers d ON ii.product_distribution_center_id = d.id
WHERE o.shipped_at IS NOT NULL AND o.delivered_at IS NOT NULL
GROUP BY d.name
ORDER BY avg_total_fulfillment_hours DESC;

-- 25. Repeat purchase interval (average days between orders for repeat customers)
SELECT
    user_id,
    COUNT(order_id) AS num_orders,
    ROUND(AVG(EXTRACT(EPOCH FROM days_between) / 86400.0), 2) AS avg_days_between_orders
FROM (
    SELECT
        user_id,
        order_id,
        created_at,
        created_at - LAG(created_at) OVER (PARTITION BY user_id ORDER BY created_at) AS days_between
    FROM orders
) t
WHERE days_between IS NOT NULL
GROUP BY user_id
HAVING COUNT(order_id) > 1
ORDER BY avg_days_between_orders;

-- 26. Inventory turnover rate (proxy: orders per inventory item)
SELECT
    p.name AS product_name,
    COUNT(DISTINCT oi.order_id) AS num_orders,
    COUNT(i.id) AS inventory_count,
    ROUND(COUNT(DISTINCT oi.order_id)::NUMERIC / NULLIF(COUNT(i.id),0), 2) AS turnover_rate
FROM products p
LEFT JOIN inventory_items i ON p.id = i.product_id
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.name
HAVING COUNT(DISTINCT oi.order_id) > 3
ORDER BY turnover_rate DESC NULLS LAST
LIMIT 20;

-- 27. Market basket analysis: top product pairs (if data allows)
-- Shows which products are most frequently bought together in the same order
SELECT
    a.product_id AS product_id_1,
    b.product_id AS product_id_2,
    COUNT(*) AS times_bought_together
FROM order_items a
JOIN order_items b ON a.order_id = b.order_id AND a.product_id < b.product_id
GROUP BY a.product_id, b.product_id
ORDER BY times_bought_together DESC
LIMIT 20;