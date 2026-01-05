create database Ex03;
use Ex03;

create table Customers(
customer_id int auto_increment primary key,
full_name varchar(255),
city varchar(255)
);

create table Orders(
order_id int primary key,
customer_id int,
order_date date,
status enum('pending', 'completed', 'cancelled'),
total_amount decimal(10,2)
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

update Orders set total_amount = 500000 where order_id = 101;
update Orders set total_amount = 300000 where order_id = 102;
update Orders set total_amount = 750000 where order_id = 103;
update Orders set total_amount = 200000 where order_id = 104;
update Orders set total_amount = 450000 where order_id = 105;

select order_date,sum(total_amount) as total_revenue,count(order_id) as total_orders
from Orders
where status = 'completed'
group by order_date
having sum(total_amount) > 10000000;









 
    



