USE social_network;

CREATE TABLE friends(
	follower_id INT,
    followed_id INT,
    PRIMARY KEY(follower_id,followed_id),
    foreign key(follower_id) references users(user_id),
    foreign key(followed_id) references users(user_id)
);
-- Tạo bảng followers và các cột count nếu chưa có.
ALTER TABLE users
ADD following_count INT DEFAULT 0;

ALTER TABLE users
ADD followers_count INT DEFAULT 0;


-- Viết Stored Procedure sp_follow_user với tham số:
-- p_follower_id INT
-- p_followed_id INT
-- Logic:
-- Kiểm tra cả hai user có tồn tại không → nếu không, ghi log lỗi (INSERT vào bảng follow_log nếu tạo) và ROLLBACK.
-- Kiểm tra không tự follow chính mình (p_follower_id <> p_followed_id).
-- Kiểm tra chưa follow trước đó (không tồn tại bản ghi trong followers).
-- Nếu mọi kiểm tra OK: INSERT vào followers, UPDATE tăng following_count của follower, UPDATE tăng followers_count của followed → COMMIT.
-- Nếu có lỗi: ROLLBACK.
DELIMITER $$
CREATE PROCEDURE sp_follow_user(p_follower_id INT,p_followed_id INT)
BEGIN
	DECLARE exist_user INT;
    START TRANSACTION;
    IF (p_follower_id = p_followed_id) THEN
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không được follow bản thân!';
    END IF;
    SELECT COUNT(*) INTO exist_user FROM users WHERE user_id IN(p_follower_id,p_followed_id);
    
	IF (exist_user <> 2) THEN
		ROLLBACK;
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Id không hợp lệ!';
    ELSE
		INSERT INTO friends(follower_id,followed_id) VALUE
        (p_follower_id,p_followed_id);
        
        UPDATE users
        SET followers_count = followers_count + 1
        WHERE user_id = p_follower_id;
        
        UPDATE users
        SET following_count = following_count + 1
        WHERE user_id = p_followed_id;
        COMMIT;
    END IF;
END $$

-- Gọi procedure với các trường hợp thành công và thất bại.
-- thành công
CALL sp_follow_user(1,2);
-- thất bại
CALL sp_follow_user(1,1);
CALL sp_follow_user(1,4);