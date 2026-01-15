USE social_network;

create table likes(
	like_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    UNIQUE(post_id,user_id),
    foreign key(post_id) references posts(post_id),
    foreign key(user_id) references users(user_id)
);

ALTER TABLE posts
ADD likes_count INT DEFAULT 0;

drop PROCEDURE create_like;

DELIMITER $$
CREATE PROCEDURE create_like(in_post_id INT, in_user_id INT)
BEGIN
	DECLARE user_exists INT;
    DECLARE author_id INT;
    -- Viết script SQL sử dụng TRANSACTION để thực hiện:
	START TRANSACTION;
    
    SELECT COUNT(*) INTO user_exists FROM users WHERE user_id = in_user_id;
    SELECT user_id INTO author_id FROM posts WHERE post_id = in_post_id;
    
    -- Nếu author_id là NULL nghĩa là không tìm thấy bài viết
    
    -- Nếu bất kỳ thao tác nào thất bại, thực hiện ROLLBACK
    IF user_exists = 0 OR author_id = 0 THEN
		ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'id khong hop le!';
	END IF;
    
    IF author_id = in_user_id THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'khong the tu like cho chinh minh!';
    END IF;
    
    INSERT INTO likes(post_id,user_id) VALUE
    (in_post_id,in_user_id);
	
    UPDATE posts
    SET likes_count = likes_count + 1
    WHERE post_id = in_post_id;
    
    COMMIT;
END $$

-- Thực hiện thử nghiệm:
-- Like lần đầu → COMMIT.
CALL create_like(2,1);
-- Like lần thứ hai cùng post và user → gây lỗi → ROLLBACK.
CALL create_like(1,1);