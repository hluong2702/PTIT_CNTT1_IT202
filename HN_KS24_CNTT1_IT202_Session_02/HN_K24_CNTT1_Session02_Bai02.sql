CREATE database Ex02;
USE Ex02;
CREATE table Student(
	id int primary key auto_increment UNIQUE,
    name VARCHAR(30) NOT NULL
);

CREATE table Course(
	id int primary key auto_increment UNIQUE,
    name VARCHAR(30) NOT NULL,
    credits INT CHECK(credits >= 0)
);

