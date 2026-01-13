-- 2) Tạo stored procedure có tham số IN nhận vào p_user_id:
-- Tạo stored procedure nhận vào mã người dùng p_user_id và trả về danh sách bài viết của user đó.Thông tin trả về gồm:]
-- PostID (post_id)
-- Nội dung (content)
-- Thời gian tạo (created_at)
DELIMITER $$
CREATE PROCEDURE getUserPost(p_user_id INT)
BEGIN
	SELECT post_id,content,created_at
    FROM posts
	WHERE user_id = p_user_id;
END$$

-- 3) Gọi lại thủ tục vừa tạo với user cụ thể mà bạn muốn
CALL getUserPost(1);

-- 4) Xóa thủ tục vừa tạo.

DROP PROCEDURE getUserPost;