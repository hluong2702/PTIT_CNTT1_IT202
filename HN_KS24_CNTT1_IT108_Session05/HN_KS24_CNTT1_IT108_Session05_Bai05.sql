CREATE database EX05;
USE EX05;

CREATE TABLE Orders(
	order_id int primary key,
    customer_id int,
    total_amount DECIMAL(10,2),
    order_date DATE , 
    status ENUM('pending', 'completed', 'cancelled')
);

INSERT INTO Orders (order_id, customer_id, total_amount, order_date, status) VALUES
(1, 1, 2500000.00, '2025-01-01', 'completed'),
(2, 2, 1800000.00, '2025-01-02', 'pending'),
(3, 3, 3200000.00, '2025-01-03', 'cancelled'),
(4, 4, 1500000.00, '2025-01-04', 'completed'),
(5, 5, 4200000.00, '2025-01-05', 'pending'),

(6, 1, 980000.00,  '2025-01-06', 'completed'),
(7, 2, 2750000.00, '2025-01-07', 'completed'),
(8, 3, 1300000.00, '2025-01-08', 'pending'),
(9, 4, 3600000.00, '2025-01-09', 'cancelled'),
(10, 5, 2100000.00, '2025-01-10', 'completed'),

(11, 1, 4500000.00, '2025-01-11', 'pending'),
(12, 2, 1700000.00, '2025-01-12', 'completed'),
(13, 3, 2900000.00, '2025-01-13', 'completed'),
(14, 4, 1250000.00, '2025-01-14', 'pending'),
(15, 5, 3900000.00, '2025-01-15', 'cancelled'),

(16, 1, 2600000.00, '2025-01-16', 'completed'),
(17, 2, 3100000.00, '2025-01-17', 'pending'),
(18, 3, 1450000.00, '2025-01-18', 'completed'),
(19, 4, 4800000.00, '2025-01-19', 'completed'),
(20, 5, 2200000.00, '2025-01-20', 'pending');

-- Trang 1: hiển thị 5 đơn hàng mới nhất
SELECT * FROM Orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5;

-- Trang 2: hiển thị 5 đơn hàng tiếp theo
SELECT * FROM Orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;

-- Trang 3: hiển thị 5 đơn hàng tiếp theo
SELECT * FROM Orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 10;