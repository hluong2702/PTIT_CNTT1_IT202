USE Ex01;

CREATE TABLE likes(
	like_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    post_id INT,
    foreign key(user_id) references users(user_id),
    foreign key(post_id) references posts(post_id),
    liked_at DATETIME DEFAULT CURRENT_TImestamp
);

INSERT INTO likes (user_id, post_id, liked_at) VALUES
(2, 1, '2025-01-10 11:00:00'),
(3, 1, '2025-01-10 13:00:00'),
(1, 3, '2025-01-11 10:00:00'),
(3, 4, '2025-01-12 16:00:00');

-- Tạo trigger AFTER INSERT và AFTER DELETE trên likes để tự động cập nhật like_count trong bảng posts.
DELIMITER $$
CREATE TRIGGER tg_afterLike
AFTER INSERT
ON likes
FOR EACH ROW
BEGIN
	UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = new.post_id;
END;

DELIMITER $$
CREATE TRIGGER tg_afterLikesDelete
AFTER DELETE
ON likes
FOR EACH ROW
BEGIN
	UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = old.post_id;
END;

-- Tạo một View tên user_statistics hiển thị: user_id, username, post_count, total_likes (tổng like_count của tất cả bài đăng của người dùng đó). 
CREATE OR REPLACE VIEW user_statistics AS
SELECT 
    u.user_id, 
    u.username, 
    u.post_count,
    COALESCE(SUM(p.like_count), 0) as total_likes
FROM users u
LEFT JOIN posts p ON u.user_id = p.user_id
GROUP BY u.user_id, u.username, u.post_count;

-- Thực hiện thêm/xóa một lượt thích và kiểm chứng:
INSERT INTO likes (user_id, post_id, liked_at) VALUES (2, 4, NOW());
SELECT * FROM posts WHERE post_id = 4;
SELECT * FROM user_statistics;

-- Xóa một lượt thích và kiểm chứng lại View.
DELETE FROM likes
WHERE like_id = 2;