USE Ex01;

create table friendships(
	follower_id INT,
    followee_id INT,
    foreign key(follower_id) references users(user_id),
    foreign key(followee_id) references users(user_id),
    status ENUM('pending', 'accepted') DEFAULT 'accepted' 
);
-- 2) Tạo trigger AFTER INSERT/DELETE trên friendships để cập nhật follower_count của followee.
DELIMITER $$
CREATE TRIGGER tg_after_insert_friend
AFTER INSERT
ON friendships
FOR EACH ROW
BEGIN
	UPDATE users
    SET follower_count = follower_count + 1
    WHERE user_id = new.followee_id;
END $$

DELIMITER $$
CREATE TRIGGER tg_delete_friend
AFTER DELETE
ON friendships
FOR EACH ROW
BEGIN
	UPDATE users
    SET follower_count = follower_count - 1
    WHERE user_id = old.followee_id;
END $$

-- 3) Tạo Procedure follow_user(follower_id, followee_id, status) xử lý logic (tránh tự follow, tránh trùng).
DELIMITER $$
CREATE PROCEDURE follow_user(in_follower_id INT, in_followee_id INT, in_status ENUM('pending', 'accepted'))
BEGIN
	IF in_follower_id = in_followee_id THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Lỗi: Không thể tự follow bản thân!';
	ELSE 
		INSERT INTO friendships(follower_id,followee_id,status) VALUE (in_follower_id, in_followee_id,in_status);
	END IF;
END $$

-- 4) Tạo View user_profile chi tiết.
CREATE VIEW user_profile AS
SELECT *
FROM users;
-- kiểm tra dữ liệu
SELECT * FROM user_profile;

-- 5) Thực hiện một số follow/unfollow và kiểm chứng follower_count, View.
CALL follow_user(1,1,'accepted');
CALL follow_user(2,1,'accepted');
CALL follow_user(3,1,'accepted');

DELETE FROM friendships
WHERE followee_id = 1 AND follower_id = 2;
