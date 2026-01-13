
CREATE DATABASE social_network;
USE social_network;

-- Bài 1: Bảng Users
DROP TABLE IF EXISTS Likes;
DROP TABLE IF EXISTS Comments;
DROP TABLE IF EXISTS Posts;
DROP TABLE IF EXISTS Friends;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Bảng Posts
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Bảng Comments
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Bảng Friends
CREATE TABLE Friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'accepted')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Bảng Likes
CREATE TABLE Likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE
);

-- Thêm dữ liệu mẫu
INSERT INTO Users (username, password, email) VALUES
('nguyenvana', 'pass123', 'vana@email.com'),
('tranthib', 'pass456', 'thib@email.com'),
('levanc', 'pass789', 'vanc@email.com'),
('phamthid', 'pass321', 'thid@email.com'),
('hoangvane', 'pass654', 'vane@email.com');

-- Hiển thị danh sách người dùng
SELECT * FROM Users;

DROP VIEW IF EXISTS vw_public_users;

CREATE VIEW vw_public_users AS
SELECT user_id, username, created_at
FROM Users;

-- Truy vấn từ View
SELECT * FROM vw_public_users;

-- So sánh với truy vấn trực tiếp
SELECT user_id, username, created_at FROM Users;

-- Tạo Index cho username
CREATE INDEX idx_username ON Users(username);

-- Truy vấn tìm kiếm
SELECT * FROM Users WHERE username = 'nguyenvana';

-- Xem kế hoạch thực thi
EXPLAIN SELECT * FROM Users WHERE username = 'nguyenvana';

DELIMITER //

DROP PROCEDURE IF EXISTS sp_create_post//

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE user_exists INT;
    
    -- Kiểm tra user có tồn tại không
    SELECT COUNT(*) INTO user_exists 
    FROM Users 
    WHERE user_id = p_user_id;
    
    IF user_exists > 0 THEN
        INSERT INTO Posts (user_id, content) 
        VALUES (p_user_id, p_content);
        SELECT 'Đăng bài thành công!' AS message;
    ELSE
        SELECT 'User không tồn tại!' AS message;
    END IF;
END//

DELIMITER ;

-- Gọi Procedure
CALL sp_create_post(1, 'Đây là bài viết đầu tiên của tôi!');
CALL sp_create_post(2, 'Hôm nay thời tiết đẹp quá!');
CALL sp_create_post(1, 'Học SQL rất thú vị!');

-- BÀI 5: VIEW NEWS FEED
DROP VIEW IF EXISTS vw_recent_posts;

CREATE VIEW vw_recent_posts AS
SELECT 
    p.post_id,
    p.content,
    u.username,
    p.created_at
FROM Posts p
INNER JOIN Users u ON p.user_id = u.user_id
WHERE p.created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
ORDER BY p.created_at DESC;

-- Truy vấn View
SELECT * FROM vw_recent_posts;

-- BÀI 6: INDEX TỐI ƯU BÀI VIẾT

-- Index đơn
CREATE INDEX idx_posts_user_id ON Posts(user_id);

-- Composite Index
CREATE INDEX idx_posts_user_created ON Posts(user_id, created_at);

-- Truy vấn bài viết của 1 user
SELECT * FROM Posts 
WHERE user_id = 1 
ORDER BY created_at DESC;

-- BÀI 7: THỐNG KÊ HOẠT ĐỘNG

DELIMITER //

DROP PROCEDURE IF EXISTS sp_count_posts//

CREATE PROCEDURE sp_count_posts(
    IN p_user_id INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM Posts
    WHERE user_id = p_user_id;
END//

DELIMITER ;

-- Gọi Procedure
CALL sp_count_posts(1, @total);
SELECT @total AS 'Tổng số bài viết';

-- BÀI 8: VIEW WITH CHECK OPTION

DROP VIEW IF EXISTS vw_active_users;

CREATE VIEW vw_active_users AS
SELECT user_id, username, email, created_at
FROM Users
WHERE is_active = TRUE
WITH CHECK OPTION;

-- Thử INSERT hợp lệ
INSERT INTO vw_active_users (username, email) 
VALUES ('usertest', 'test@email.com');

-- UPDATE thông qua View
UPDATE vw_active_users 
SET username = 'usertest_updated' 
WHERE username = 'usertest';

-- BÀI 9: QUẢN LÝ KẾT BẠN

DELIMITER //

DROP PROCEDURE IF EXISTS sp_add_friend//

CREATE PROCEDURE sp_add_friend(
    IN p_user_id INT,
    IN p_friend_id INT
)
BEGIN
    DECLARE friend_exists INT;
    
    -- Kiểm tra không kết bạn với chính mình
    IF p_user_id = p_friend_id THEN
        SELECT 'Không thể kết bạn với chính mình!' AS message;
    ELSE
        -- Kiểm tra đã là bạn chưa
        SELECT COUNT(*) INTO friend_exists
        FROM Friends
        WHERE user_id = p_user_id AND friend_id = p_friend_id;
        
        IF friend_exists > 0 THEN
            SELECT 'Đã gửi lời mời kết bạn trước đó!' AS message;
        ELSE
            INSERT INTO Friends (user_id, friend_id, status)
            VALUES (p_user_id, p_friend_id, 'pending');
            SELECT 'Gửi lời mời kết bạn thành công!' AS message;
        END IF;
    END IF;
END//

DELIMITER ;

-- Gọi Procedure
CALL sp_add_friend(1, 2);
CALL sp_add_friend(1, 3);
CALL sp_add_friend(2, 3);

-- BÀI 10: GỢI Ý BẠN BÈ

DELIMITER //

DROP PROCEDURE IF EXISTS sp_suggest_friends//

CREATE PROCEDURE sp_suggest_friends(
    IN p_user_id INT,
    INOUT p_limit INT
)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_user_id INT;
    DECLARE v_username VARCHAR(50);
    DECLARE counter INT DEFAULT 0;
    
    -- Tạo bảng tạm
    DROP TEMPORARY TABLE IF EXISTS temp_suggestions;
    CREATE TEMPORARY TABLE temp_suggestions (
        suggested_user_id INT,
        suggested_username VARCHAR(50)
    );
    
    -- Lấy danh sách user chưa là bạn
    INSERT INTO temp_suggestions
    SELECT u.user_id, u.username
    FROM Users u
    WHERE u.user_id != p_user_id
    AND u.user_id NOT IN (
        SELECT friend_id FROM Friends WHERE user_id = p_user_id
    )
    LIMIT p_limit;
    
    -- Trả về kết quả
    SELECT * FROM temp_suggestions;
    
    -- Cập nhật số lượng gợi ý thực tế
    SELECT COUNT(*) INTO p_limit FROM temp_suggestions;
END//

DELIMITER ;

-- Gọi Procedure
SET @limit = 5;
CALL sp_suggest_friends(1, @limit);
SELECT @limit AS 'Số lượng gợi ý';

-- BÀI 11: THỐNG KÊ TƯƠNG TÁC

-- Thêm dữ liệu Likes mẫu
INSERT INTO Likes (user_id, post_id) VALUES
(2, 1), (3, 1), (4, 1), (5, 1),
(1, 2), (3, 2), (4, 2),
(1, 3), (2, 3);

-- Truy vấn Top 5 bài viết nhiều like
SELECT 
    p.post_id,
    p.content,
    u.username AS author,
    COUNT(l.user_id) AS total_likes
FROM Posts p
INNER JOIN Users u ON p.user_id = u.user_id
LEFT JOIN Likes l ON p.post_id = l.post_id
GROUP BY p.post_id, p.content, u.username
ORDER BY total_likes DESC
LIMIT 5;

-- Tạo View
DROP VIEW IF EXISTS vw_top_posts;

CREATE VIEW vw_top_posts AS
SELECT 
    p.post_id,
    p.content,
    u.username AS author,
    COUNT(l.user_id) AS total_likes
FROM Posts p
INNER JOIN Users u ON p.user_id = u.user_id
LEFT JOIN Likes l ON p.post_id = l.post_id
GROUP BY p.post_id, p.content, u.username
ORDER BY total_likes DESC
LIMIT 5;

-- Index cho Likes
CREATE INDEX idx_likes_post_id ON Likes(post_id);

SELECT * FROM vw_top_posts;


-- BÀI 12: QUẢN LÝ BÌNH LUẬN

DELIMITER //

DROP PROCEDURE IF EXISTS sp_add_comment//

CREATE PROCEDURE sp_add_comment(
    IN p_user_id INT,
    IN p_post_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE user_exists INT;
    DECLARE post_exists INT;
    
    -- Kiểm tra user tồn tại
    SELECT COUNT(*) INTO user_exists 
    FROM Users 
    WHERE user_id = p_user_id;
    
    -- Kiểm tra post tồn tại
    SELECT COUNT(*) INTO post_exists 
    FROM Posts 
    WHERE post_id = p_post_id;
    
    IF user_exists = 0 THEN
        SELECT 'User không tồn tại!' AS message;
    ELSEIF post_exists = 0 THEN
        SELECT 'Bài viết không tồn tại!' AS message;
    ELSE
        INSERT INTO Comments (user_id, post_id, content)
        VALUES (p_user_id, p_post_id, p_content);
        SELECT 'Thêm bình luận thành công!' AS message;
    END IF;
END//

DELIMITER ;

-- Gọi Procedure
CALL sp_add_comment(2, 1, 'Bài viết hay quá!');
CALL sp_add_comment(3, 1, 'Mình cũng nghĩ vậy!');
CALL sp_add_comment(1, 2, 'Cảm ơn bạn!');

-- View hiển thị bình luận
DROP VIEW IF EXISTS vw_post_comments;

CREATE VIEW vw_post_comments AS
SELECT 
    c.comment_id,
    c.post_id,
    c.content AS comment_content,
    u.username AS commenter,
    c.created_at
FROM Comments c
INNER JOIN Users u ON c.user_id = u.user_id
ORDER BY c.created_at DESC;

SELECT * FROM vw_post_comments;

-- BÀI 13: QUẢN LÝ LƯỢT THÍCH

DELIMITER //

DROP PROCEDURE IF EXISTS sp_like_post//

CREATE PROCEDURE sp_like_post(
    IN p_user_id INT,
    IN p_post_id INT
)
BEGIN
    DECLARE like_exists INT;
    
    -- Kiểm tra đã thích chưa
    SELECT COUNT(*) INTO like_exists
    FROM Likes
    WHERE user_id = p_user_id AND post_id = p_post_id;
    
    IF like_exists > 0 THEN
        SELECT 'Bạn đã thích bài viết này rồi!' AS message;
    ELSE
        INSERT INTO Likes (user_id, post_id)
        VALUES (p_user_id, p_post_id);
        SELECT 'Thích bài viết thành công!' AS message;
    END IF;
END//

DELIMITER ;

-- Gọi Procedure
CALL sp_like_post(1, 1);
CALL sp_like_post(1, 1); -- Thử thích lại

-- View thống kê lượt thích
DROP VIEW IF EXISTS vw_post_likes;

CREATE VIEW vw_post_likes AS
SELECT 
    p.post_id,
    p.content,
    COUNT(l.user_id) AS total_likes
FROM Posts p
LEFT JOIN Likes l ON p.post_id = l.post_id
GROUP BY p.post_id, p.content;

SELECT * FROM vw_post_likes;

-- BÀI 14: TÌM KIẾM NGƯỜI DÙNG & BÀI VIẾT

DELIMITER //

DROP PROCEDURE IF EXISTS sp_search_social//

CREATE PROCEDURE sp_search_social(
    IN p_option INT,
    IN p_keyword VARCHAR(100)
)
BEGIN
    IF p_option = 1 THEN
        -- Tìm người dùng
        SELECT user_id, username, email, created_at
        FROM Users
        WHERE username LIKE CONCAT('%', p_keyword, '%');
        
    ELSEIF p_option = 2 THEN
        -- Tìm bài viết
        SELECT 
            p.post_id,
            p.content,
            u.username AS author,
            p.created_at
        FROM Posts p
        INNER JOIN Users u ON p.user_id = u.user_id
        WHERE p.content LIKE CONCAT('%', p_keyword, '%');
        
    ELSE
        SELECT 'Lựa chọn không hợp lệ! Chọn 1 (tìm user) hoặc 2 (tìm post)' AS message;
    END IF;
END//

DELIMITER ;

-- Gọi Procedure
-- Tìm người dùng có username chứa "an"
CALL sp_search_social(1, 'an');

-- Tìm bài viết có nội dung chứa "SQL"
CALL sp_search_social(2, 'SQL');

-- Thử option không hợp lệ
CALL sp_search_social(3, 'test');

-- KIỂM TRA TỔNG QUAN HỆ THỐNG

-- Xem tất cả bảng
SHOW TABLES;

-- Xem tất cả View
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Xem tất cả Stored Procedure
SHOW PROCEDURE STATUS WHERE Db = 'social_network';

-- Xem tất cả Index
SHOW INDEX FROM Users;
SHOW INDEX FROM Posts;
SHOW INDEX FROM Likes;