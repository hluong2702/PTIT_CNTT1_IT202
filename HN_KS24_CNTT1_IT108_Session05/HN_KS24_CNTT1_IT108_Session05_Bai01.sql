create database Ex01;
use Ex01;

create table Product(
product_id int auto_increment primary key,
product_name varchar(255),
price decimal(10,2),
stock int,
status enum('active','inactive')
);

insert into Product(product_id,product_name,price,stock,status) values
('1','Laptop Asus Vivobook', 18000000, 7, 'active'),
('2','Điện thoại Samsung Galaxy A54', 8500000, 15, 'active'),
('3','Tai nghe Bluetooth JBL', 1200000, 20, 'inactive');

select *from Product;
select *from Product where status = 'active';
select *from Product where price >1000000;
select *from Product 
where status = 'active'
order by price asc;

