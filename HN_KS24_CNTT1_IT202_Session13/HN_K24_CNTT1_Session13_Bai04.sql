USE Ex01;

CREATE table post_history(
	history_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    foreign key(post_id) references posts(post_id),
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME,
    changed_by_user_id INT
);


-- BEFORE UPDATE trên posts: Nếu content thay đổi, INSERT bản ghi vào post_history với old_content (OLD.content), new_content (NEW.content), changed_at NOW(), và giả sử changed_by_user_id là user_id của post.
DELIMITER $$
CREATE TRIGGER tg_before_update_post
BEFORE UPDATE
ON posts
FOR EACH ROW
BEGIN
	IF old.content <> new.content THEN
		INSERT INTO post_history(post_id,old_content,new_content,changed_at,changed_by_user_id) VALUE
		(old.post_id,old.content,new.content,CURDATE(),old.user_id);
	END IF;
END;

-- AFTER DELETE trên posts: Có thể ghi log hoặc để CASCADE.
DELIMITER $$
CREATE TRIGGER tg_after_delete_post
AFTER DELETE
ON posts
FOR EACH ROW
BEGIN
	INSERT INTO post_history(post_id,old_content,new_content,changed_at,changed_by_user_id) VALUE
    (old.post_id,old.content,'Đã xoá',CURDATE(),old.user_id);
END;

DELIMITER ;

-- 4) Thực hiện UPDATE nội dung một số bài đăng, sau đó SELECT từ post_history để xem lịch sử.
UPDATE posts
SET content = 'Nội dung lần 3: Chào mọi người, mình mới sửa bài!' 
WHERE post_id = 1;

-- 5) Kiểm tra kết hợp với trigger like_count từ bài trước vẫn hoạt động khi UPDATE post.
INSERT INTO likes (user_id, post_id) VALUES (1, 3);

SELECT * FROM posts;
SELECT * FROM post_history;