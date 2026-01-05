create database Ex06;
use Ex6;

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

create table products (
    product_id int primary key,
    product_name varchar(255),
    price decimal(10,2)
);

create table order_items (
    order_id int,
    product_id int,
    quantity int,
    foreign key (product_id) references products(product_id)
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

insert into products (product_id, product_name, price) values
(1, 'laptop', 15000000),
(2, 'chuot', 300000),
(3, 'ban phim', 800000),
(4, 'man hinh', 5000000),
(5, 'tai nghe', 1200000);

insert into order_items (order_id, product_id, quantity) values
(101, 1, 1),
(102, 1, 2),
(103, 2, 5),
(104, 3, 4),
(105, 4, 2),
(106, 5, 3);

select p.product_name,sum(oi.quantity) as total_quantity_sold,sum(p.price * oi.quantity) as total_revenue,avg(p.price) as avg_price
from products p join order_items oi on p.product_id = oi.product_id
group by p.product_id, p.product_name
having sum(oi.quantity) >= 10
order by total_revenue desc
limit 5;

    



