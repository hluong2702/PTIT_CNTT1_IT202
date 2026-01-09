CREATE database miniproject;
USE miniproject;


CREATE table customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(10) NOT NULL UNIQUE
);

CREATE table categories(
	category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(255) NOT NULL
);

CREATE table products(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL check(price > 0),
    category_id INT,
    FOREIGN KEY(category_id) references categories(category_id)
);

CREATE table orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    FOREIGN KEY(customer_id) references customers(customer_id),
    order_date DATE DEFAULT(curdate()),
    status ENUM('Pending','Completed','Cancel')
);

CREATE table order_items(
	order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    FOREIGN KEY(order_id) references orders(order_id),
    FOREIGN KEY(product_id) references products(product_id),
    quantity INT CHECK(quantity >= 0)
);

-- 1. customers (Giữ nguyên)
INSERT INTO customers (customer_name, email, phone) VALUES
('Nguyen Van A', 'a@gmail.com', '0900000001'),
('Tran Thi B', 'b@gmail.com', '0900000002'),
('Le Van C', 'c@gmail.com', '0900000003'),
('Pham Thi D', 'd@gmail.com', '0900000004'),
('Hoang Van E', 'e@gmail.com', '0900000005'),
('Vu Thi F', 'f@gmail.com', '0900000006'),
('Do Van G', 'g@gmail.com', '0900000007'),
('Bui Thi H', 'h@gmail.com', '0900000008'),
('Dang Van I', 'i@gmail.com', '0900000009'),
('Ngo Thi K', 'k@gmail.com', '0900000010');

-- 2. categories (Giữ nguyên)
INSERT INTO categories (category_name) VALUES
('Electronics'), ('Fashion'), ('Books'), ('Home'), ('Toys'),
('Sports'), ('Beauty'), ('Food'), ('Office'), ('Accessories');

-- 3. products 
-- (Sửa đổi: Gom nhóm sản phẩm vào chung Category để tính giá trung bình có ý nghĩa hơn)
INSERT INTO products (product_name, price, category_id) VALUES
('Laptop Dell', 1500.00, 1),      -- Electronics
('Iphone 15', 1200.00, 1),        -- Electronics (Thêm sản phẩm cho Cate 1)
('T-shirt', 20.00, 2),            -- Fashion
('Jeans', 50.00, 2),              -- Fashion (Thêm sản phẩm cho Cate 2)
('Novel Book', 15.50, 3),         -- Books
('Vacuum Cleaner', 120.00, 4),    -- Home
('Toy Car', 25.00, 5),            -- Toys
('Football', 30.00, 6),           -- Sports
('Skincare Cream', 45.00, 7),     -- Beauty
('Office Chair', 200.00, 9);      -- Office

-- 4. orders 
-- (Sửa đổi: Khách hàng số 1 mua 2 lần để thỏa mãn điều kiện HAVING COUNT >= 2)
INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2025-01-01', 'Completed'), -- Khách 1 mua lần 1
(1, '2025-01-02', 'Pending'),   -- Khách 1 mua lần 2 (Để test query khách có >= 2 đơn)
(2, '2025-01-03', 'Completed'),
(3, '2025-01-04', 'Cancel'),
(4, '2025-01-05', 'Completed'),
(5, '2025-01-06', 'Pending'),
(6, '2025-01-07', 'Completed'),
(7, '2025-01-08', 'Pending'),
(8, '2025-01-09', 'Cancel'),
(9, '2025-01-10', 'Completed');

-- 5. order_items
-- (Sửa đổi: Đơn hàng số 1 mua nhiều loại sản phẩm để test hàm SUM quantity)
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1), -- Đơn 1 mua Laptop
(1, 3, 2), -- Đơn 1 mua thêm 2 cái áo (Để test query 1 đơn có nhiều dòng sp)
(2, 2, 1), -- Đơn 2 (của khách 1) mua Iphone
(3, 2, 1),
(4, 5, 5), -- Đơn 4 mua số lượng lớn (Để test MAX quantity)
(5, 6, 1),
(6, 7, 2),
(7, 8, 3),
(8, 9, 1),
(9, 10, 1);

-- PHẦN A – TRUY VẤN DỮ LIỆU CƠ BẢN
	-- Lấy danh sách tất cả danh mục sản phẩm trong hệ thống.
	SELECT c.category_id 'Mã danh mục', c.category_name 'Tên danh mục'
    FROM categories c;
	
    -- Lấy danh sách đơn hàng có trạng thái là COMPLETED
    SELECT o.order_id 'Mã đơn hàng', o.customer_id 'Mã khách hàng', o.order_date 'Ngày', o.status 'Trạng thái'
    FROM orders o
    WHERE o.status = 'Completed';
	
    -- Lấy danh sách sản phẩm và sắp xếp theo giá giảm dần
    SELECT p.product_id 'Mã sản phẩm', p.product_name 'Tên sản phẩm', p.price 'Giá sản phẩm', p.category_id 'Mã danh mục'
    FROM products p
    ORDER BY p.price DESC;
	
    -- Lấy 5 sản phẩm có giá cao nhất, bỏ qua 2 sản phẩm đầu tiên
    SELECT p.product_id 'Mã sản phẩm', p.product_name 'Tên sản phẩm', p.price 'Giá sản phẩm', p.category_id 'Mã danh mục'
    FROM products p
    ORDER BY p.price DESC 
    LIMIT 5 OFFSET 2;
    
-- PHẦN B – TRUY VẤN NÂNG CAO
	-- Lấy danh sách sản phẩm kèm tên danh mục
    SELECT p.product_id 'Mã sản phẩm', p.product_name 'Tên sản phẩm', p.price 'Giá sản phẩm', c.category_name 'Tên danh mục'
    FROM products p
    JOIN categories c ON c.category_id = p.category_id;
	
    -- Lấy danh sách đơn hàng gồm:
		-- order_id
		-- order_date
		-- customer_name
		-- status
	SELECT o.order_id 'Mã đơn hàng', o.order_date 'Ngày', c.customer_name 'Tên khách hàng', o.status 'Trạng thái'
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id;
	
    -- Tính tổng số lượng sản phẩm trong từng đơn hàng
    SELECT oi.order_id AS 'Mã đơn hàng', SUM(oi.quantity) AS 'Tổng số lượng sản phẩm'
	FROM order_items oi
	GROUP BY oi.order_id;
	
    -- Thống kê số đơn hàng của mỗi khách hàng
    SELECT c.customer_id AS 'Mã khách hàng', c.customer_name AS 'Tên khách hàng', COUNT(o.order_id) AS 'Tổng số đơn hàng'
	FROM customers c
	JOIN orders o ON c.customer_id = o.customer_id
	GROUP BY c.customer_id, c.customer_name;
	
    -- Lấy danh sách khách hàng có tổng số đơn hàng ≥ 2
    SELECT c.customer_id AS 'Mã khách hàng', c.customer_name AS 'Tên khách hàng', COUNT(o.order_id) AS 'Tổng số đơn hàng'
	FROM customers c
	JOIN orders o ON c.customer_id = o.customer_id
	GROUP BY c.customer_id, c.customer_name
	HAVING COUNT(o.order_id) >= 2;
    
	-- Thống kê giá trung bình, thấp nhất và cao nhất của sản phẩm theo danh mục
    SELECT c.category_name, AVG(p.price) 'Giá trung bình', MIN(p.price) 'Giá thấp nhất', MAX(p.price) 'Giá cao nhất'
	FROM products p
	JOIN categories c ON p.category_id = c.category_id
	GROUP BY c.category_name;
    
-- PHẦN C – TRUY VẤN LỒNG (SUBQUERY)
	-- Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
    SELECT p.product_id 'Mã sản phẩm', p.product_name 'Tên sản phẩm',p.price 'Giá sản phẩm'
    FROM products p
    WHERE price >(
		SELECT AVG(price)
        FROM products
    );
    
	-- Lấy danh sách khách hàng đã từng đặt ít nhất một đơn hàng
    SELECT c.customer_id 'Mã khách hàng', c.customer_name 'Tên khách hàng'
    FROM customers c
    WHERE c.customer_id IN (
		SELECT DISTINCT o.customer_id
        FROM orders o
    );
    
	-- Lấy đơn hàng có tổng số lượng sản phẩm lớn nhất.
    SELECT order_id 'Mã đơn hàng', SUM(quantity) AS 'Số lượng sản phẩm'
	FROM order_items
	GROUP BY order_id
	HAVING SUM(quantity) = (
		SELECT MAX(sum_qty) 
		FROM (
			SELECT SUM(quantity) AS sum_qty 
			FROM order_items 
			GROUP BY order_id
		) AS temp
	);
    
	-- Lấy tên khách hàng đã mua sản phẩm thuộc danh mục có giá trung bình cao nhất
    SELECT DISTINCT c.customer_name
	FROM customers c
	JOIN orders o ON c.customer_id = o.customer_id
	JOIN order_items oi ON o.order_id = oi.order_id
	JOIN products p ON oi.product_id = p.product_id
	WHERE p.category_id = (
		SELECT category_id
		FROM products
		GROUP BY category_id
		ORDER BY AVG(price) DESC
		LIMIT 1
	);
    
	-- Từ bảng tạm (subquery), thống kê tổng số lượng sản phẩm đã mua của từng khách hàng
    SELECT temp.customer_name, SUM(temp.quantity) AS total_products_bought
	FROM (
		SELECT c.customer_id, c.customer_name, oi.quantity
		FROM customers c
		JOIN orders o ON c.customer_id = o.customer_id
		JOIN order_items oi ON o.order_id = oi.order_id
	) AS temp 
	GROUP BY temp.customer_id;
    
	-- Viết lại truy vấn lấy sản phẩm có giá cao nhất, đảm bảo:
		-- Subquery chỉ trả về một giá trị
		-- Không gây lỗi “Subquery returns more than 1 row”
        SELECT product_id, product_name, price
		FROM products
		WHERE price = (
			SELECT MAX(price) 
			FROM products
		);

