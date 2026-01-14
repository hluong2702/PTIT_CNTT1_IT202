DROP DATABASE IF EXISTS Ex01;
CREATE DATABASE Ex01;
USE Ex01;

CREATE TABLE users(
	user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at DATE,
    follower_count INT DEFAULT 0,
    post_count INT DEFAULT 0
);

CREATE TABLE posts(
	post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    foreign key(user_id) references users(user_id),
    content TEXT,
    created_at DATETIME,
    like_count INT DEFAULT 0
);

INSERT INTO users (username, email, created_at) VALUES
('alice', 'alice@example.com', '2025-01-01'),
('bob', 'bob@example.com', '2025-01-02'),
('charlie', 'charlie@example.com', '2025-01-03');

-- Trigger AFTER INSERT trên posts: Khi thêm bài đăng mới, tăng post_count của người dùng tương ứng lên 1.
DELIMITER $$
CREATE TRIGGER tg_afterPost
AFTER INSERT
ON posts
FOR EACH ROW
BEGIN
	UPDATE users
    SET post_count = post_count + 1
    WHERE user_id = new.user_id;
END;
-- Trigger AFTER DELETE trên posts: Khi xóa bài đăng, giảm post_count của người dùng tương ứng đi 1.
DELIMITER $$
CREATE TRIGGER tg_afterDelete
AFTER DELETE
ON posts
FOR EACH ROW
BEGIN
	UPDATE users
    SET post_count = post_count - 1
    WHERE user_id = old.user_id;
END;

DELIMITER $$

INSERT INTO posts (user_id, content, created_at) VALUES
(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),
(1, 'Second post by Alice', '2025-01-10 12:00:00'),
(2, 'Bob first post', '2025-01-11 09:00:00'),
(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

SELECT * FROM users;

DELETE FROM posts
WHERE post_id = 2;