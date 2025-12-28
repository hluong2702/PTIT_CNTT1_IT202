CREATE database Ex01;
USE Ex01;

CREATE table Student(
	id int primary key auto_increment,
    name VARCHAR(30) NOT NULL,
    date_birth DATE NOT NULL
);

CREATE table Class(
	id int primary key auto_increment,
    name VARCHAR(30) NOT NULL,
    year YEAR NOT NULL
);

ALTER table Student 
ADD column class_id INT NOT NULL references Class(id)