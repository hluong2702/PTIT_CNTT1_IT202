-- 2) Viết procedure tên CreatePostWithValidation nhận IN p_user_id (INT), IN p_content (TEXT). Nếu độ dài content < 5 ký tự thì không thêm bài viết và SET một biến thông báo lỗi (có thể dùng OUT result_message VARCHAR(255) để trả về thông báo “Nội dung quá ngắn” hoặc “Thêm bài viết thành công”).
DELIMITER $$

CREATE PROCEDURE CreatePostWithValidation(
    IN p_user_id INT,
    IN p_content TEXT,
    OUT result_message VARCHAR(255)
)
BEGIN
    IF CHAR_LENGTH(p_content) < 5 THEN
        SET result_message = 'Nội dung quá ngắn';
    ELSE
        INSERT INTO posts(user_id, content)
        VALUES (p_user_id, p_content);

        SET result_message = 'Thêm bài viết thành công';
    END IF;
END $$

-- 3) Gọi thủ tục và thử insert các trường hợp 
CALL CreatePostWithValidation(1, 'Hi', @result);
SELECT @result;

CALL CreatePostWithValidation(1, 'Đây là bài viết hợp lệ', @result);
SELECT @result;

-- 4) Kiểm tra các kết quả
SELECT * FROM posts
WHERE user_id = 1
ORDER BY id DESC;

-- 5) Xóa thủ tục vừa khởi tạo trên
DROP PROCEDURE IF EXISTS CreatePostWithValidation;

-- Gợi ý: Sử dụng IF để kiểm tra CHAR_LENGTH(p_content) < 5, nếu đúng thì SET result_message và không INSERT, ngược lại INSERT bình thường.