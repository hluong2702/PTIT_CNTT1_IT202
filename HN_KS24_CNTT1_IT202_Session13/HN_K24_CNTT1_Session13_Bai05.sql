-- 1)Tạo Stored Procedure add_user(username, email, created_at) thực hiện INSERT vào users.
DELIMITER $$
CREATE PROCEDURE add_user(in_username VARCHAR(255), in_email VARCHAR(255), in_created_at DATE)
BEGIN
	INSERT INTO users(username,email,created_at) VALUE
    (in_username,in_email,in_created_at);
END;

-- 2) Tạo trigger BEFORE INSERT trên users:
DELIMITER $$
CREATE TRIGGER tg_before_insert_user
BEFORE INSERT
ON users
FOR EACH ROW
BEGIN
    -- Kiểm tra email chứa '@' và '.'.
    IF (NEW.email NOT LIKE '%@%') OR (NEW.email NOT LIKE '%.%') THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Lỗi: Email không đúng định dạng (thiếu @ hoặc .)';
    END IF;

    -- Kiểm tra username chỉ chứa chữ cái, số và underscore.
    IF NEW.username REGEXP '[^a-zA-Z0-9_]' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Lỗi: Username chứa ký tự đặc biệt không cho phép!';
    END IF;
END $$

-- 3) Gọi procedure với dữ liệu hợp lệ và không hợp lệ để kiểm thử.
CALL add_user('!sondao1','sondao1@gmail.com',CURDATE());
CALL add_user('sondao1','sondao2@gmail',CURDATE());
CALL add_user('sondao2','sondao2@gmail.com',CURDATE());
-- 4) SELECT * FROM users để xem kết quả.
SELECT * FROM users;
