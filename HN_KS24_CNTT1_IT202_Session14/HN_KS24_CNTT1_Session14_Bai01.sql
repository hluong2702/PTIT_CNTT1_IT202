DROP DATABASE IF EXISTS social_network;
CREATE DATABASE social_network;
USE social_network;

CREATE TABLE users(
	user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    posts_count INT DEFAULT 0
);

CREATE TABLE posts(
	post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    foreign key(user_id) references users(user_id),
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP PROCEDURE create_post;

DELIMITER $$
CREATE PROCEDURE create_post(in_user_id INT, in_content TEXT)
BEGIN
	DECLARE user_exists INT;
    -- Viết script SQL sử dụng TRANSACTION để thực hiện:
	START TRANSACTION;
    
    SELECT COUNT(*) INTO user_exists FROM users WHERE user_id = in_user_id;
    -- Nếu bất kỳ thao tác nào thất bại, thực hiện ROLLBACK.
    IF in_content IS NULL OR LENGTH(TRIM(in_content)) = 0 THEN
		ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'content khong hop le!';
	END IF;
    
    IF user_exists = 0 THEN
		ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'id khong ton tai!';
	END IF;
    
    -- INSERT một bản ghi mới vào bảng posts (với user_id và content do bạn chọn).
	INSERT INTO posts(user_id,content) VALUE
    (in_user_id, in_content);
    -- UPDATE tăng posts_count +1 cho user tương ứng.
    UPDATE users
    SET posts_count = posts_count + 1
    WHERE user_id = in_user_id;
    -- Nếu thành công, thực hiện COMMIT.
    COMMIT;
    
END $$

-- Chạy script với ít nhất 2 trường hợp:
-- Trường hợp thành công (COMMIT).
CALL create_post(1,'content 1');
-- Trường hợp gây lỗi cố ý (ví dụ: vi phạm ràng buộc khóa ngoại bằng user_id không tồn tại) để kiểm tra ROLLBACK.
CALL create_post(999,'content 1');
CALL create_post(1,'');