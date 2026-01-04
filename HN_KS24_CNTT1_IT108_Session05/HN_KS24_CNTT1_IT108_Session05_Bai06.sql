CREATE database Ex06;
USE Ex06;

CREATE TABLE product(
	product_id int primary key,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2),
    stock int,
    sold_quantity int,
    status ENUM("active","inactive")
);

INSERT INTO product (product_id, product_name, price, stock, sold_quantity, status) VALUES
(1, 'Laptop Dell Inspiron', 15000000.00, 10, 5, 'active'),
(2, 'Laptop HP Pavilion', 16500000.00, 8, 3, 'active'),
(3, 'Laptop Asus Vivobook', 14000000.00, 12, 6, 'active'),
(4, 'MacBook Air M1', 23000000.00, 5, 4, 'active'),
(5, 'Chuột không dây Logitech', 350000.00, 50, 20, 'active'),
(6, 'Chuột gaming Razer', 1200000.00, 30, 12, 'active'),
(7, 'Bàn phím cơ Keychron K2', 2200000.00, 25, 10, 'active'),
(8, 'Bàn phím Logitech K380', 750000.00, 40, 18, 'active'),
(9, 'Màn hình Samsung 24 inch', 4200000.00, 15, 7, 'inactive'),
(10, 'Màn hình LG 27 inch', 5200000.00, 10, 5, 'active'),
(11, 'Tai nghe Sony WH-1000XM5', 8500000.00, 8, 6, 'active'),
(12, 'Tai nghe AirPods Pro', 6200000.00, 20, 14, 'active'),
(13, 'USB Kingston 64GB', 250000.00, 100, 60, 'active'),
(14, 'Ổ cứng SSD Samsung 1TB', 3200000.00, 18, 9, 'active'),
(15, 'Webcam Logitech C920', 2800000.00, 12, 4, 'inactive'),
(16, 'Chuột Logitech M331', 450000.00, 60, 25, 'active'),
(17, 'Chuột Microsoft Bluetooth', 950000.00, 40, 18, 'active'),
(18, 'Bàn phím cơ Akko 3087', 1800000.00, 22, 9, 'active'),
(19, 'Bàn phím cơ DareU EK87', 1500000.00, 30, 14, 'active'),
(20, 'Tai nghe Logitech G Pro', 2900000.00, 15, 7, 'active'),

(21, 'Tai nghe HyperX Cloud II', 2600000.00, 18, 8, 'active'),
(22, 'Loa Bluetooth JBL Go 3', 1200000.00, 35, 16, 'active'),
(23, 'Loa Bluetooth Sony SRS-XE200', 2800000.00, 20, 10, 'active'),
(24, 'Webcam Rapoo C280', 1600000.00, 25, 11, 'active'),
(25, 'Ổ cứng SSD Kingston 512GB', 1900000.00, 28, 13, 'active'),

(26, 'Ổ cứng SSD WD Blue 500GB', 2100000.00, 24, 12, 'active'),
(27, 'USB Sandisk 128GB', 420000.00, 80, 50, 'active'),
(28, 'Balo Laptop Xiaomi', 850000.00, 45, 20, 'inactive'),
(29, 'Đế tản nhiệt Laptop Cooler Master', 1350000.00, 32, 15, 'active'),
(30, 'Chuột gaming SteelSeries Rival 3', 1700000.00, 26, 10, 'active');

	-- Trang 1
    SELECT * FROM product
    WHERE status = 'active' AND price BETWEEN 1000000 AND 3000000
    ORDER BY price ASC
    LIMIT 10;
	-- Trang 2
    SELECT * FROM product
    WHERE status = 'active' AND price BETWEEN 1000000 AND 3000000
    ORDER BY price ASC
    LIMIT 10 OFFSET 10;