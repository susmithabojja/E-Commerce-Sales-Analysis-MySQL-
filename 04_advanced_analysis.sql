USE ecommerce_project;

-- 09. Customers whose paid spending is above the average spending
-- Average is across customers with at least one qualifying paid order.
WITH customer_spending AS (
    SELECT o.customer_id, SUM(p.amount) AS total_spending
    FROM orders o
    JOIN payments p ON p.order_id = o.order_id
    WHERE o.status = 'Completed' AND p.payment_status = 'Paid'
    GROUP BY o.customer_id
)
SELECT cs.customer_id, c.customer_name, cs.total_spending
FROM customer_spending cs
JOIN customers c ON c.customer_id = cs.customer_id
WHERE cs.total_spending > (SELECT AVG(total_spending) FROM customer_spending)
ORDER BY cs.total_spending DESC;

-- 10. Rank products by gross line-item revenue on completed orders
WITH product_revenue AS (
    SELECT p.product_id, p.product_name,
           SUM(oi.quantity * p.price) AS revenue
    FROM products p
    JOIN order_items oi ON oi.product_id = p.product_id
    JOIN orders o ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY p.product_id, p.product_name
)
SELECT product_id, product_name, revenue,
       RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM product_revenue
ORDER BY revenue_rank, product_name;

-- 11. Monthly collected revenue (paid payments on completed orders)
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       SUM(p.amount) AS monthly_revenue
FROM orders o
JOIN payments p ON p.order_id = o.order_id
WHERE o.status = 'Completed' AND p.payment_status = 'Paid'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- 12. Most recent order for each customer (includes ties only one row)
WITH ranked_orders AS (
    SELECT customer_id, order_id, order_date, status,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY order_date DESC, order_id DESC
           ) AS rn
    FROM orders
)
SELECT customer_id, order_id, order_date, status
FROM ranked_orders
WHERE rn = 1
ORDER BY customer_id;

-- 13. Overall paid revenue, paid completed orders and average order value
SELECT SUM(p.amount) AS total_paid_revenue,
       COUNT(DISTINCT o.order_id) AS paid_completed_orders,
       ROUND(SUM(p.amount) / COUNT(DISTINCT o.order_id), 2) AS average_order_value
FROM orders o
JOIN payments p ON p.order_id = o.order_id
WHERE o.status = 'Completed' AND p.payment_status = 'Paid';

-- 14. Cancellation rate across all orders
SELECT COUNT(*) AS total_orders,
       SUM(status = 'Cancelled') AS cancelled_orders,
       ROUND(100.0 * SUM(status = 'Cancelled') / COUNT(*), 2) AS cancellation_rate_pct
FROM orders;

-- 15. Second-highest distinct product revenue
WITH product_revenue AS (
    SELECT p.product_id, p.product_name,
           SUM(oi.quantity * p.price) AS revenue
    FROM products p
    JOIN order_items oi ON oi.product_id = p.product_id
    JOIN orders o ON o.order_id = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY p.product_id, p.product_name
),
ranked AS (
    SELECT *, DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
    FROM product_revenue
)
SELECT product_id, product_name, revenue
FROM ranked
WHERE revenue_rank = 2;

-- 16. Highest-spending customer(s) in each city
WITH customer_spending AS (
    SELECT c.customer_id, c.customer_name, c.city, SUM(p.amount) AS total_spending
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    JOIN payments p ON p.order_id = o.order_id
    WHERE o.status = 'Completed' AND p.payment_status = 'Paid'
    GROUP BY c.customer_id, c.customer_name, c.city
),
ranked AS (
    SELECT *, RANK() OVER (PARTITION BY city ORDER BY total_spending DESC) AS city_rank
    FROM customer_spending
)
SELECT customer_id, customer_name, city, total_spending
FROM ranked
WHERE city_rank = 1
ORDER BY city;

-- 17. Running monthly paid revenue
WITH monthly_sales AS (
    SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month, SUM(p.amount) AS revenue
    FROM orders o
    JOIN payments p ON p.order_id = o.order_id
    WHERE o.status = 'Completed' AND p.payment_status = 'Paid'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT month, revenue,
       SUM(revenue) OVER (ORDER BY month) AS running_revenue
FROM monthly_sales
ORDER BY month;

-- 18. Products never included in any order (regardless of order status)
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
WHERE oi.product_id IS NULL;
