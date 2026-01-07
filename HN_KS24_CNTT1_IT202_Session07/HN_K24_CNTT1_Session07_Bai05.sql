CREATE database Ex05;
USE Ex05;

CREATE table customers(
	id int primary key,
	name VARCHAR(255),
	email VARCHAR(255) UNIQUE
);

CREATE table orders(
	id int primary key,
	customer_id int,
    foreign key(customer_id) references customers(id),
	order_date DATE,
	total_amount DECIMAL(10,2)
);

INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(101, 1, '2024-01-05', 150.50),
(102, 2, '2024-01-10', 320.00),
(103, 3, '2024-01-12', 99.99),
(104, 1, '2024-02-01', 450.75),
(105, 4, '2024-02-03', 210.40),
(106, 5, '2024-02-10', 180.00),
(107, 6, '2024-02-15', 560.90);


INSERT INTO customers (id, name, email) VALUES
(1, 'Nguyen Van An', 'an.nguyen@example.com'),
(2, 'Tran Thi Binh', 'binh.tran@example.com'),
(3, 'Le Van Cuong', 'cuong.le@example.com'),
(4, 'Pham Thi Dao', 'dao.pham@example.com'),
(5, 'Hoang Van Em', 'em.hoang@example.com'),
(6, 'Vo Thi Hoa', 'hoa.vo@example.com'),
(7, 'Dang Van Khoa', 'khoa.dang@example.com');


-- Tìm khách hàng có tổng số tiền mua hàng lớn nhất
-- Sử dụng ít nhất 2 cấp subquery
-- Dùng các hàm SUM và MAX
-- KHÔNG dùng JOIN

SELECT 
    c.id, 
    c.name, 
    c.email,
    (SELECT SUM(total_amount) 
     FROM orders o 
     WHERE o.customer_id = c.id) AS tong_tien
FROM customers c
WHERE c.id IN (
        SELECT customer_id
        FROM orders
        GROUP BY customer_id
        HAVING SUM(total_amount) = (
            SELECT MAX(tong_tien_tung_nguoi)
            FROM (
                SELECT SUM(total_amount) as tong_tien_tung_nguoi
                FROM orders
                GROUP BY customer_id
            ) as sub
        )
    );
