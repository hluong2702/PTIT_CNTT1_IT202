CREATE DATABASE quanlybanhang;
USE quanlybanhang;

-- Bảng Customers (Khách hàng)
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    address VARCHAR(255) NULL
);

-- Bảng Products (Sản phẩm)
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    category VARCHAR(50) NOT NULL
);

-- Bảng Employees (Nhân viên)
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(100) NOT NULL,
    birthday DATE NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    revenue DECIMAL(10,2) DEFAULT 0
);

-- Bảng Orders (Đơn hàng)
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    employee_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- Bảng OrderDetails (Chi tiết đơn hàng)
CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Câu 3: CHỈNH SỬA CẤU TRÚC BẢNG

-- Câu 3.1: Thêm cột email vào bảng Customers
ALTER TABLE Customers 
ADD COLUMN email VARCHAR(100) NOT NULL UNIQUE;

-- Câu 3.2: Xóa cột birthday khỏi bảng Employees
ALTER TABLE Employees 
DROP COLUMN birthday;


-- PHẦN 2: TRUY VẤN DỮ LIỆU
-- Câu 4: Chèn dữ liệu

-- Thêm dữ liệu vào bảng Customers
INSERT INTO Customers (customer_name, phone, address, email) VALUES
('Nguyễn Văn An', '0901234567', '123 Đường Lê Lợi, Quận 1, TP.HCM', 'nguyenvanan@email.com'),
('Trần Thị Bình', '0912345678', '456 Đường Nguyễn Huệ, Quận 1, TP.HCM', 'tranthibinh@email.com'),
('Lê Văn Cường', '0923456789', '789 Đường Hai Bà Trưng, Quận 3, TP.HCM', 'levancuong@email.com'),
('Phạm Thị Dung', '0934567890', '321 Đường Trần Hưng Đạo, Quận 5, TP.HCM', 'phamthidung@email.com'),
('Hoàng Văn Em', '0945678901', '654 Đường Võ Văn Tần, Quận 3, TP.HCM', 'hoangvanem@email.com');

-- Thêm dữ liệu vào bảng Products
INSERT INTO Products (product_name, price, quantity, category) VALUES
('Laptop HP Pavilion', 15000000.00, 50, 'Laptop'),
('iPhone 15 Pro', 29990000.00, 30, 'Smartphone'),
('Samsung Galaxy S24', 24990000.00, 40, 'Smartphone'),
('iPad Air', 18990000.00, 25, 'Tablet'),
('AirPods Pro', 6990000.00, 100, 'Audio');

-- Thêm dữ liệu vào bảng Employees
INSERT INTO Employees (employee_name, position, salary, revenue) VALUES
('Nguyễn Thị Hoa', 'Quản lý', 20000000.00, 0),
('Trần Văn Kiên', 'Nhân viên bán hàng', 12000000.00, 0),
('Lê Thị Lan', 'Nhân viên bán hàng', 11000000.00, 0),
('Phạm Văn Minh', 'Nhân viên kho', 9000000.00, 0),
('Hoàng Thị Nga', 'Nhân viên bán hàng', 11500000.00, 0);

-- Thêm dữ liệu vào bảng Orders
INSERT INTO Orders (customer_id, employee_id, order_date, total_amount) VALUES
(1, 2, '2025-01-15 10:30:00', 44990000.00),
(2, 3, '2025-01-16 14:20:00', 18990000.00),
(3, 2, '2025-01-17 09:15:00', 31980000.00),
(4, 5, '2025-01-18 16:45:00', 15000000.00),
(5, 3, '2025-01-19 11:00:00', 36980000.00);

-- Thêm dữ liệu vào bảng OrderDetails
INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
(1, 2, 1, 29990000.00),
(1, 1, 1, 15000000.00),
(2, 4, 1, 18990000.00),
(3, 3, 1, 24990000.00),
(3, 5, 1, 6990000.00),
(4, 1, 1, 15000000.00),
(5, 2, 1, 29990000.00),
(5, 5, 1, 6990000.00);

-- Câu 5: TRUY VẤN CƠ BẢN

-- Câu 5.1: Lấy danh sách tất cả khách hàng
SELECT 
    customer_id,
    customer_name,
    email,
    phone,
    address
FROM Customers;

-- Câu 5.2: Sửa thông tin sản phẩm có product_id = 1
UPDATE Products 
SET 
    product_name = 'Laptop Dell XPS',
    price = 99.99
WHERE product_id = 1;

-- Câu 5.3: Lấy thông tin đơn đặt hàng
SELECT 
    o.order_id,
    c.customer_name,
    e.employee_name,
    o.total_amount,
    o.order_date
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN Employees e ON o.employee_id = e.employee_id;

-- Câu 6: TRUY VẤN ĐẦY ĐỦ

-- Câu 6.1: Đếm số lượng đơn hàng của mỗi khách hàng
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- Câu 6.2: Thống kê tổng doanh thu của từng nhân viên trong năm hiện tại
SELECT 
    e.employee_id,
    e.employee_name,
    COALESCE(SUM(o.total_amount), 0) AS revenue
FROM Employees e
LEFT JOIN Orders o ON e.employee_id = o.employee_id 
    AND YEAR(o.order_date) = YEAR(CURDATE())
GROUP BY e.employee_id, e.employee_name;

-- Câu 6.3: Thống kê sản phẩm có số lượng đặt hàng > 100 trong tháng hiện tại
SELECT 
    p.product_id,
    p.product_name,
    SUM(od.quantity) AS total_quantity
FROM Products p
INNER JOIN OrderDetails od ON p.product_id = od.product_id
INNER JOIN Orders o ON od.order_id = o.order_id
WHERE YEAR(o.order_date) = YEAR(CURDATE()) 
    AND MONTH(o.order_date) = MONTH(CURDATE())
GROUP BY p.product_id, p.product_name
HAVING SUM(od.quantity) > 100
ORDER BY total_quantity DESC;

-- Câu 7: TRUY VẤN NÂNG CAO

-- Câu 7.1: Danh sách khách hàng chưa từng đặt hàng
SELECT 
    c.customer_id,
    c.customer_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Câu 7.2: Danh sách sản phẩm có giá cao hơn giá trung bình
SELECT 
    product_id,
    product_name,
    price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

-- Câu 7.3: Khách hàng có mức chi tiêu cao nhất
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spending
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) = (
    SELECT MAX(total_spending)
    FROM (
        SELECT SUM(total_amount) AS total_spending
        FROM Orders
        GROUP BY customer_id
    ) AS spending_summary
);

-- Câu 8: TẠO VIEW

-- Câu 8.1: View hiển thị danh sách đơn hàng
CREATE VIEW view_order_list AS
SELECT 
    o.order_id,
    c.customer_name,
    e.employee_name,
    o.total_amount,
    o.order_date
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN Employees e ON o.employee_id = e.employee_id
ORDER BY o.order_date DESC;

-- Câu 8.2: View hiển thị chi tiết đơn hàng
CREATE VIEW view_order_detail_product AS
SELECT 
    od.order_detail_id,
    p.product_name,
    od.quantity,
    od.unit_price
FROM OrderDetails od
INNER JOIN Products p ON od.product_id = p.product_id
ORDER BY od.quantity DESC;

-- Câu 9: TẠO THỦ TỤC LƯU TRỮ

-- Câu 9.1: Thủ tục thêm nhân viên mới
DELIMITER $$
CREATE PROCEDURE proc_insert_employee(
    IN p_employee_name VARCHAR(100),
    IN p_position VARCHAR(50),
    IN p_salary DECIMAL(10,2),
    OUT p_new_employee_id INT
)
BEGIN
    INSERT INTO Employees (employee_name, position, salary, revenue)
    VALUES (p_employee_name, p_position, p_salary, 0);
    SET p_new_employee_id = LAST_INSERT_ID();
END$$
DELIMITER ;

-- Câu 9.2: Thủ tục lọc chi tiết đơn hàng theo mã đơn hàng
DELIMITER $$
CREATE PROCEDURE proc_get_orderdetails(
    IN p_order_id INT
)
BEGIN
    SELECT 
        od.order_detail_id,
        od.order_id,
        od.product_id,
        p.product_name,
        od.quantity,
        od.unit_price,
        (od.quantity * od.unit_price) AS line_total
    FROM OrderDetails od
    INNER JOIN Products p ON od.product_id = p.product_id
    WHERE od.order_id = p_order_id;
END$$
DELIMITER ;

-- Câu 9.3: Thủ tục tính số lượng loại sản phẩm trong đơn hàng
DELIMITER $$
CREATE PROCEDURE proc_cal_total_amount_by_order(
    IN p_order_id INT,
    OUT p_product_count INT
)
BEGIN
    SELECT COUNT(DISTINCT product_id)
    INTO p_product_count
    FROM OrderDetails
    WHERE order_id = p_order_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trigger_after_insert_order_details
BEFORE INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    
    SELECT quantity INTO current_stock
    FROM Products
    WHERE product_id = NEW.product_id;
    
    IF current_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng sản phẩm trong kho không đủ';
    ELSE
        UPDATE Products
        SET quantity = quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE proc_insert_order_details(
    IN p_order_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_unit_price DECIMAL(10,2)
)
BEGIN
    DECLARE order_exists INT;
    DECLARE line_total DECIMAL(10,2);
    
    START TRANSACTION;
    
    SELECT COUNT(*) INTO order_exists
    FROM Orders
    WHERE order_id = p_order_id;
    
    IF order_exists = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không tồn tại mã hóa đơn';
    ELSE
        SET line_total = p_quantity * p_unit_price;
	
        INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price)
        VALUES (p_order_id, p_product_id, p_quantity, p_unit_price);
        
        UPDATE Orders
        SET total_amount = total_amount + line_total
        WHERE order_id = p_order_id;
        COMMIT;
    END IF;
END$$
DELIMITER ;


CALL proc_insert_employee('Vũ Văn Phúc', 'Nhân viên IT', 13000000.00, @new_id);
SELECT @new_id AS employee_id_moi_them;

CALL proc_get_orderdetails(1);

CALL proc_cal_total_amount_by_order(1, @product_count);
SELECT @product_count AS so_loai_san_pham;

CALL proc_insert_order_details(1, 4, 2, 18990000.00);
