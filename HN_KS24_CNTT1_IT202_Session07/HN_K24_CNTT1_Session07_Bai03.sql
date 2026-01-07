CREATE database Ex03;
USE Ex03;

CREATE table orders(
	id int primary key,
	order_date DATE,
	total_amount DECIMAL(10,2)
);

INSERT INTO orders (id, order_date, total_amount) VALUES
(101, '2024-01-05', 150.50),
(102, '2024-01-10', 320.00),
(103, '2024-01-12', 99.99),
(104, '2024-02-01', 450.75),
(105, '2024-02-03', 210.40),
(106, '2024-02-10', 180.00),
(107, '2024-02-15', 560.90);

-- Lấy danh sách đơn hàng có giá trị lớn hơn giá trị trung bình của tất cả đơn hàng
-- Subquery sử dụng hàm AVG
-- KHÔNG dùng JOIN

SELECT * 
FROM orders
WHERE total_amount > (
    SELECT AVG(total_amount) 
    FROM orders
);
