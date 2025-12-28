CREATE database Ex04;
USE Ex04;

CREATE table Lecturer(
	id INT PRIMARY KEY auto_increment,
    name VARCHAR(30) NOT NULL ,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Course (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    credits INT CHECK (credits >= 0),
    lecturer_id INT NOT NULL,
    FOREIGN KEY (lecturer_id) REFERENCES Lecturer(id)
);