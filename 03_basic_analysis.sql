USE ecommerce_project;

-- 01. Customers from Hyderabad
SELECT * FROM customers WHERE city = 'Hyderabad';

-- 02. Completed orders
SELECT * FROM orders WHERE status = 'Completed';

-- 03. Products priced above 5,000
SELECT product_name, price
FROM products
WHERE price > 5000
ORDER BY price DESC;

-- 04. Customer count by city
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC, city;

-- 05. Total orders by customer (includes customers with zero orders)
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_orders DESC, c.customer_id;

-- 06. Customers who have never placed an order
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 07. Top 3 products by units sold on completed orders
SELECT p.product_name, SUM(oi.quantity) AS total_quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity DESC, p.product_name
LIMIT 3;

-- 08. Repeat customers (more than one completed order)
SELECT c.customer_id, c.customer_name, COUNT(*) AS completed_order_count
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(*) > 1;
