-- 2)Viết procedure tên CalculateUserActivityScore nhận IN p_user_id (INT), trả về OUT activity_score (INT). Điểm được tính: mỗi post +10 điểm, mỗi comment +5 điểm, mỗi like nhận được +3 điểm. Sử dụng CASE hoặc IF để phân loại mức hoạt động (ví dụ: >500 “Rất tích cực”, 200-500 “Tích cực”, <200 “Bình thường”) và trả thêm OUT activity_level (VARCHAR(50)).
DELIMITER $$

CREATE PROCEDURE CalculateUserActivityScore(
    IN p_user_id INT,
    OUT activity_score INT,
    OUT activity_level VARCHAR(50)
)
BEGIN
    DECLARE v_post_count INT DEFAULT 0;
    DECLARE v_comment_count INT DEFAULT 0;
    DECLARE v_like_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_post_count
    FROM posts
    WHERE user_id = p_user_id;

    SELECT COUNT(*)
    INTO v_comment_count
    FROM comments
    WHERE user_id = p_user_id;

    SELECT COUNT(*)
    INTO v_like_count
    FROM likes l
    JOIN posts p ON l.post_id = p.post_id
    WHERE p.user_id = p_user_id;

    SET activity_score =
          v_post_count * 10
        + v_comment_count * 5
        + v_like_count * 3;

    CASE
        WHEN activity_score > 500 THEN
            SET activity_level = 'Rất tích cực';
        WHEN activity_score BETWEEN 200 AND 500 THEN
            SET activity_level = 'Tích cực';
        ELSE
            SET activity_level = 'Bình thường';
    END CASE;

END $$
-- Gợi ý: Dùng các SELECT COUNT riêng cho posts, comments, likes (JOIN posts và likes), tính tổng điểm, sau đó dùng CASE để xác định level.

-- 3) Gọi thủ tục trên select ra activity_score và activity_level
CALL CalculateUserActivityScore(2, @score, @level);
SELECT @score AS activity_score, @level AS activity_level;


-- 4) Xóa thủ tục vừa khởi tạo trên
DROP PROCEDURE IF EXISTS CalculateUserActivityScore;
