create database Ex01;
use Ex01;
DROP TABLE Orders;

create table Customers(
customer_id int auto_increment primary key,
full_name varchar(255),
city varchar(255)
);

create table Orders(
order_id int ,
customer_id int,
order_date date,
status enum('pending', 'completed', 'cancelled')
);

insert into Customers (customer_id, full_name, city) values
(1, 'Nguyễn Văn An', 'Hà Nội'),
(2, 'Trần Thị Bình', 'TP.HCM'),
(3, 'Lê Văn Cường', 'Đà Nẵng'),
(4, 'Phạm Thị Dung', 'Hà Nội'),
(5, 'Hoàng Văn Em', 'Cần Thơ');

insert into Orders (order_id, customer_id, order_date, status) values
(101, 1, '2025-01-01', 'completed'),
(102, 1, '2025-01-05', 'pending'),
(103, 2, '2025-01-03', 'completed'),
(104, 3, '2025-01-10', 'cancelled'),
(105, 2, '2025-01-12', 'completed');

SELECT o.order_id,o.order_date,o.status,c.full_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT c.customer_id,c.full_name,COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;

SELECT c.customer_id,c.full_name,COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 1;



