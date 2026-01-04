CREATE database EX03;
USE EX03;

CREATE TABLE Orders(
	order_id int primary key,
    customer_id int,
    total_amount DECIMAL(10,2),
    order_date DATE , 
    status ENUM('pending', 'completed', 'cancelled')
);

INSERT INTO Orders (order_id, customer_id, total_amount, order_date, status) VALUES
(1, 1, 5500000.00, '2025-01-05', 'completed'),
(2, 2, 1800000.00, '2025-01-06', 'pending'),
(3, 3, 3200000.00, '2025-01-10', 'cancelled'),
(4, 1, 1500000.00, '2025-01-08', 'completed'),
(5, 4, 4200000.00, '2025-01-09', 'pending'),
(6, 4, 4200000.00, '2025-01-07', 'pending');

-- Lấy danh sách đơn hàng đã hoàn thành
SELECT * FROM Orders WHERE status = 'completed';

-- Lấy các đơn hàng có tổng tiền > 5.000.000
SELECT * FROM Orders WHERE total_amount > 5000000;

-- Hiển thị 5 đơn hàng mới nhất
SELECT * FROM Orders
ORDER BY order_date DESC
LIMIT 5;

-- Hiển thị các đơn hàng đã hoàn thành, sắp xếp theo tổng tiền giảm dần
SELECT * FROM Orders
WHERE status = 'completed'
ORDER BY total_amount DESC;