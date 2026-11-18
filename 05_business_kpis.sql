USE ecommerce_project;

-- 19. Revenue by product category (gross line-item sales on completed orders)
SELECT p.category, SUM(oi.quantity * p.price) AS gross_sales
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY gross_sales DESC;

-- 20. Payment method mix by paid transaction amount
SELECT p.payment_method, COUNT(*) AS paid_transactions,
       SUM(p.amount) AS collected_amount
FROM payments p
JOIN orders o ON o.order_id = p.order_id
WHERE p.payment_status = 'Paid' AND o.status = 'Completed'
GROUP BY p.payment_method
ORDER BY collected_amount DESC;

-- 21. Customers with both completed and cancelled orders
SELECT c.customer_id, c.customer_name
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.status = 'Completed') > 0
   AND SUM(o.status = 'Cancelled') > 0;

-- 22. Product contribution to total gross sales
WITH product_sales AS (
    SELECT p.product_id, p.product_name,
           SUM(oi.quantity * p.price) AS gross_sales
    FROM products p
    JOIN order_items oi ON oi.product_id = p.product_id
    JOIN orders o ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY p.product_id, p.product_name
)
SELECT product_name, gross_sales,
       ROUND(100.0 * gross_sales / SUM(gross_sales) OVER (), 2) AS contribution_pct
FROM product_sales
ORDER BY gross_sales DESC;

-- 23. Month-over-month paid revenue change
WITH monthly AS (
    SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
           SUM(p.amount) AS revenue
    FROM orders o
    JOIN payments p ON p.order_id = o.order_id
    WHERE o.status = 'Completed' AND p.payment_status = 'Paid'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),
with_previous AS (
    SELECT month, revenue,
           LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly
)
SELECT month, revenue, previous_month_revenue,
       ROUND(100.0 * (revenue - previous_month_revenue) /
             NULLIF(previous_month_revenue, 0), 2) AS mom_growth_pct
FROM with_previous
ORDER BY month;

-- 24. Average number of items per completed order
WITH order_quantities AS (
    SELECT o.order_id, SUM(oi.quantity) AS units_in_order
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status = 'Completed'
    GROUP BY o.order_id
)
SELECT ROUND(AVG(units_in_order), 2) AS avg_units_per_completed_order
FROM order_quantities;

-- 25. Order status distribution
SELECT status, COUNT(*) AS order_count,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM orders), 2) AS pct_of_orders
FROM orders
GROUP BY status
ORDER BY order_count DESC;
