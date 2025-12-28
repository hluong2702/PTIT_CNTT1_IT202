CREATE DATABASE Ex03;
USE Ex03;

CREATE TABLE Student (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE Course (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    credits INT CHECK (credits >= 0)
);

CREATE TABLE Enrollment (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    register_date DATE NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(id),
    FOREIGN KEY (course_id) REFERENCES Course(id)
);


