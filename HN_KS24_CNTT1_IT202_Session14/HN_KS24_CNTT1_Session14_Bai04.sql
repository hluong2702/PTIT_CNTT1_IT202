USE social_network;

CREATE TABLE comments(
	comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE posts
ADD comments_count INT DEFAULT 0;

-- Viết Stored Procedure sp_post_comment với tham số:
-- p_post_id INT, p_user_id INT, p_content TEXT
-- Logic:
-- START TRANSACTION
-- INSERT vào comments
-- SAVEPOINT after_insert
-- UPDATE tăng comments_count +1 cho post
-- Nếu có lỗi ở bước UPDATE (giả sử gây lỗi cố ý trong test), ROLLBACK TO after_insert
-- Nếu thành công toàn bộ → COMMIT
-- Gọi procedure với trường hợp thành công và trường hợp gây lỗi ở bước UPDATE để kiểm tra savepoint.

DELIMITER $$

CREATE PROCEDURE sp_post_comment(
    p_post_id INT,
    p_user_id INT,
    p_content TEXT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK TO after_insert;
        COMMIT;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi khi cập nhật comments_count';
    END;

    START TRANSACTION;

    INSERT INTO comments(post_id, user_id, content)
    VALUES (p_post_id, p_user_id, p_content);

    SAVEPOINT after_insert;

    UPDATE posts
    SET comments_count = comments_count + 1
    WHERE post_id = p_post_id;

    COMMIT;
END $$

DELIMITER ;


CALL sp_post_comment(1,1,'comment 1');
CALL sp_post_comment(999,1,'comment 1');
