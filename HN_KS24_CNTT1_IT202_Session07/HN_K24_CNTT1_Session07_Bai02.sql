CREATE database Ex02;
USE Ex02;

CREATE table products(
	id int primary key,
	name VARCHAR(255),
	price DECIMAL(10,2)
);

CREATE table order_items(
	order_id int primary key,
	product_id int,
    foreign key(product_id) references products(id),
	quantity int
);

INSERT INTO products (id, name, price) VALUES
(1, 'Laptop Dell', 25000000.00),
(2, 'iPhone 14', 22000000.00),
(3, 'Samsung TV', 18000000.00),
(4, 'AirPods Pro', 5500000.00),
(5, 'Chuột Logitech', 800000.00),
(6, 'Bàn phím cơ', 2500000.00),
(7, 'Màn hình LG', 7200000.00);


INSERT INTO order_items (order_id, product_id, quantity) VALUES
(101, 1, 1),
(102, 4, 2),
(103, 1, 1),
(104, 2, 1),
(105, 6, 1),
(106, 5, 1),
(107, 7, 2);

-- Lấy danh sách sản phẩm đã từng được bán
-- Subquery lấy product_id từ bảng order_items
-- Sử dụng IN
-- KHÔNG dùng JOIN

SELECT *
FROM products p 
WHERE p.id IN (
    SELECT DISTINCT product_id
    FROM order_items
);

