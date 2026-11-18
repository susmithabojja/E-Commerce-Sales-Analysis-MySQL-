USE ecommerce_project;

INSERT INTO customers VALUES
(1, 'Arun', 'Hyderabad', '2025-01-10'),
(2, 'Priya', 'Bangalore', '2025-02-15'),
(3, 'Rahul', 'Hyderabad', '2025-03-20'),
(4, 'Sneha', 'Chennai', '2025-04-05'),
(5, 'Kiran', 'Mumbai', '2025-05-12'),
(6, 'Meena', 'Bangalore', '2025-06-18'),
(7, 'Vijay', 'Hyderabad', '2025-07-25'),
(8, 'Ananya', 'Pune', '2025-08-10');

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 60000),
(102, 'Mobile', 'Electronics', 25000),
(103, 'Headphones', 'Electronics', 2000),
(104, 'Chair', 'Furniture', 8000),
(105, 'Desk', 'Furniture', 12000),
(106, 'Keyboard', 'Accessories', 1500),
(107, 'Mouse', 'Accessories', 800),
(108, 'Monitor', 'Electronics', 15000);

INSERT INTO orders VALUES
(1001, 1, '2025-09-01', 'Completed'),
(1002, 2, '2025-09-02', 'Completed'),
(1003, 1, '2025-09-05', 'Completed'),
(1004, 3, '2025-09-06', 'Cancelled'),
(1005, 4, '2025-09-08', 'Completed'),
(1006, 5, '2025-09-10', 'Completed'),
(1007, 2, '2025-09-12', 'Completed'),
(1008, 6, '2025-09-15', 'Pending'),
(1009, 7, '2025-09-18', 'Completed'),
(1010, 3, '2025-09-20', 'Completed'),
(1011, 8, '2025-09-22', 'Completed'),
(1012, 1, '2025-09-25', 'Pending');

INSERT INTO order_items VALUES
(1, 1001, 101, 1),
(2, 1001, 103, 2),
(3, 1002, 102, 1),
(4, 1002, 106, 1),
(5, 1003, 108, 1),
(6, 1003, 107, 2),
(7, 1004, 101, 1),
(8, 1005, 104, 2),
(9, 1005, 107, 1),
(10, 1006, 105, 1),
(11, 1006, 106, 2),
(12, 1007, 103, 3),
(13, 1007, 102, 1),
(14, 1008, 108, 1),
(15, 1009, 101, 1),
(16, 1009, 103, 1),
(17, 1010, 104, 1),
(18, 1010, 105, 1),
(19, 1011, 106, 3),
(20, 1011, 107, 2),
(21, 1012, 102, 1);

INSERT INTO payments VALUES
(1, 1001, 'Credit Card', 'Paid', 64000),
(2, 1002, 'UPI', 'Paid', 26500),
(3, 1003, 'Credit Card', 'Paid', 16600),
(4, 1004, 'UPI', 'Refunded', 60000),
(5, 1005, 'Cash', 'Paid', 16800),
(6, 1006, 'UPI', 'Paid', 15000),
(7, 1007, 'Credit Card', 'Paid', 31000),
(8, 1008, 'UPI', 'Pending', 15000),
(9, 1009, 'Credit Card', 'Paid', 62000),
(10, 1010, 'Cash', 'Paid', 20000),
(11, 1011, 'UPI', 'Paid', 6100),
(12, 1012, 'Credit Card', 'Pending', 25000);
