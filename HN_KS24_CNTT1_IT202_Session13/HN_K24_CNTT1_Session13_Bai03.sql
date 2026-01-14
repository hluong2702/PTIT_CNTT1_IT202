USE Ex01;
-- BEFORE INSERT: Kiểm tra không cho phép user like bài đăng của chính mình (nếu user_id = user_id của post thì RAISE ERROR).
DELIMITER $$
CREATE TRIGGER tg_validateUserLikes
BEFORE INSERT
ON likes
FOR EACH ROW
BEGIN
	DECLARE author_id INT;
    
    SELECT user_id INTO author_id 
    FROM posts 
    WHERE post_id = NEW.post_id;

    IF NEW.user_id = author_id THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Lỗi: Không thể tự like bài viết chính mình!';
    END IF;
END;

-- AFTER INSERT/DELETE/UPDATE: Cập nhật like_count trong posts tương ứng (tăng/giảm khi thêm/xóa, điều chỉnh khi UPDATE post_id).
-- Update likes
DELIMITER $$
CREATE TRIGGER tg_UpdateLikeCount_AfterUpdate
AFTER UPDATE ON likes
FOR EACH ROW
BEGIN
	-- giảm like ở bài cũ
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
    
    -- tăng like ở bài mới
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
    
END $$
DELIMITER ;

-- Thực hiện các thao tác kiểm thử:
-- Thử like bài của chính mình (phải báo lỗi).
INSERT INTO likes (user_id, post_id) VALUES (1, 1);

-- Thêm like hợp lệ, kiểm tra like_count.
INSERT INTO likes (user_id, post_id) VALUES (2, 1);
INSERT INTO likes (user_id, post_id) VALUES (3, 1);

-- UPDATE một like sang post khác, kiểm tra like_count của cả hai post.
UPDATE likes 
SET post_id = 2 
WHERE user_id = 3 AND post_id = 1;
SELECT * FROM posts;
-- Xóa like và kiểm tra.
DELETE FROM likes 
WHERE user_id = 2 AND post_id = 1;

-- Kiểm tra kết quả
SELECT * FROM posts WHERE post_id = 1;