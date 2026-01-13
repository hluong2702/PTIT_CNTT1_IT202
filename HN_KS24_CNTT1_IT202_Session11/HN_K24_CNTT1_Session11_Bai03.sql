-- 2) Viết stored procedure tên CalculateBonusPoints nhận hai tham số:

-- p_user_id (INT, IN) – ID của user
-- p_bonus_points (INT, INOUT) – Điểm thưởng ban đầu (khi gọi procedure, bạn truyền vào một giá trị điểm khởi đầu, ví dụ 100).
-- Trong procedure:
-- Đếm số lượng bài viết (posts) của user đó.
-- Nếu số bài viết ≥ 10, cộng thêm 50 điểm vào p_bonus_points.
-- Nếu số bài viết ≥ 20, cộng thêm tổng cộng 100 điểm (thay vì chỉ 50).
-- Cuối cùng, tham số p_bonus_points sẽ được sửa đổi và trả ra giá trị mới.
-- Gợi ý:
-- Sử dụng SELECT để lấy số bài viết, lưu vào biến tạm.
-- Dùng IF-ELSEIF-ELSE để kiểm tra điều kiện và cộng điểm trực tiếp vào tham số INOUT
DELIMITER $$

CREATE PROCEDURE CalculateBonusPoints(
    IN p_user_id INT,
    INOUT p_bonus_points INT
)
BEGIN
    DECLARE v_post_count INT DEFAULT 0;

    -- Đếm số bài viết của user
    SELECT COUNT(*)
    INTO v_post_count
    FROM posts
    WHERE user_id = p_user_id;

    -- Cộng điểm theo số bài viết
    IF v_post_count >= 20 THEN
        SET p_bonus_points = p_bonus_points + 100;
    ELSEIF v_post_count >= 10 THEN
        SET p_bonus_points = p_bonus_points + 50;
    END IF;
END $$

-- 3) Gọi thủ tục trên với giá trị id user và p_bonus_points bất kì mà bạn muốn cập nhật
SET @bonus_points = 100;

CALL CalculateBonusPoints(3, @bonus_points);

-- 4) Select ra p_bonus_points 
SELECT @bonus_points AS final_bonus_points;

-- 5) Xóa thủ tục mới khởi tạo trên 
DROP PROCEDURE IF EXISTS CalculateBonusPoints;
