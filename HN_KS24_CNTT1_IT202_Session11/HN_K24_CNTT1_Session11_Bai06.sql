-- 2)  Viết stored procedure tên NotifyFriendsOnNewPost nhận hai tham số IN:

-- p_user_id (INT) – ID của người đăng bài
-- p_content (TEXT) – Nội dung bài viết
-- Procedure sẽ thực hiện hai việc:

-- Thêm một bài viết mới vào bảng posts với user_id và content được truyền vào.
-- Tự động gửi thông báo loại 'new_post' vào bảng notifications cho tất cả bạn bè đã accepted (cả hai chiều trong bảng friends).
-- Nội dung thông báo: “[full_name của người đăng] đã đăng một bài viết mới”.
-- Không gửi thông báo cho chính người đăng bài.
DELIMITER $$

CREATE PROCEDURE NotifyFriendsOnNewPost(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    DECLARE v_post_id INT;
    DECLARE v_full_name VARCHAR(255);

    SELECT full_name
    INTO v_full_name
    FROM users
    WHERE user_id = p_user_id;

    INSERT INTO posts(user_id, content, created_at)
    VALUES (p_user_id, p_content, NOW());

    SET v_post_id = LAST_INSERT_ID();

    INSERT INTO notifications(user_id, type, content, created_at)
    SELECT
        friend_user_id,
        'new_post',
        CONCAT(v_full_name, ' đã đăng một bài viết mới'),
        NOW()
    FROM (
        SELECT friend_id AS friend_user_id
        FROM friends
        WHERE user_id = p_user_id
          AND status = 'accepted'
        UNION
        SELECT user_id AS friend_user_id
        FROM friends
        WHERE friend_id = p_user_id
          AND status = 'accepted'
    ) AS all_friends
    WHERE friend_user_id <> p_user_id;

END $$

-- 3) Gọi procedue trên và thêm bài viết mới 
CALL NotifyFriendsOnNewPost(
    3,
    'Hôm nay mình vừa học xong Stored Procedure trong MySQL!'
);


-- 4) Select ra những thông báo của bài viết vừa đăng
SELECT n.*, u.full_name
FROM notifications n
JOIN users u ON n.user_id = u.user_id
WHERE n.type = 'new_post'
ORDER BY n.created_at DESC;


-- 5) Xóa thủ tục vừa khởi tạo trên
DROP PROCEDURE IF EXISTS NotifyFriendsOnNewPost;
