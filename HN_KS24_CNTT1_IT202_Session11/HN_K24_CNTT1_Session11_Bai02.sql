-- 2) Tính tổng like của bài viết
-- Viết stored procedure CalculatePostLikes nhận vào:
-- IN p_post_id: mã bài viết
-- OUT total_likes: tổng số lượt like nhận được trên tất cả bài viết của người dùng đó
   -- Gợi ý:
-- IN: p_post_id 
-- OUT: total_likes
-- Logic: truyền vào post_id để đếm số likes post đó
DELIMITER $$
CREATE PROCEDURE CalculatePostLikes(p_post_id INT, OUT total_likes INT)
BEGIN
	SELECT COUNT(*)
    INTO total_likes
    FROM likes
    WHERE post_id = p_post_id;
END$$

-- 3) Thực hiện gọi stored procedure CalculatePostLikes với một post cụ thể và truy vấn giá trị của tham số OUT total_likes sau khi thủ tục thực thi.
CALL CalculatePostLikes(101,@count);
SELECT @count;

-- 4) Xóa thủ tục vừa mới tạo trên
DROP PROCEDURE CalculatePostLikes;