CREATE database EX02;
USE EX02;

CREATE TABLE Customer(
	customer_id int primary key,
    full_name VARCHAR(255),
    email VARCHAR(255),
    city VARCHAR(255),
    status ENUM("active","inactive")
);

INSERT INTO Customer (customer_id, full_name, email, city, status) VALUES
(1, 'Nguyễn Văn An', 'an.nguyen@gmail.com', 'Hà Nội', 'active'),
(2, 'Trần Thị Bình', 'binh.tran@gmail.com', 'TP. Hồ Chí Minh', 'active'),
(3, 'Lê Hoàng Cường', 'cuong.le@gmail.com', 'Đà Nẵng', 'inactive'),
(4, 'Phạm Minh Đức', 'duc.pham@gmail.com', 'Cần Thơ', 'active'),
(5, 'Võ Thị Lan', 'lan.vo@gmail.com', 'Hải Phòng', 'inactive');

-- Lấy danh sách tất cả khách hàng
SELECT * FROM Customer;

-- Lấy khách hàng ở TP.HCM
SELECT * FROM Customer
WHERE city = "TP. Hồ Chí Minh";

-- Lấy khách hàng đang hoạt động và ở Hà Nội
SELECT * FROM Customer
WHERE status = "active" AND city = "Hà Nội";

-- Sắp xếp danh sách khách hàng theo tên (A → Z)
SELECT * FROM Customer
ORDER BY full_name ASC;