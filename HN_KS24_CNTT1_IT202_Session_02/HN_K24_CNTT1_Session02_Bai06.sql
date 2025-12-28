CREATE database Ex06;
USE Ex06;

CREATE table Student(
	id int primary key auto_increment UNIQUE,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE Class (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE Course(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE table Lecturer(
	id INT PRIMARY KEY auto_increment,
    name VARCHAR(30) NOT NULL ,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Enrollment (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    register_date DATE NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(id),
    FOREIGN KEY (course_id) REFERENCES Course(id)
);

CREATE table Score(
	student_id INT NOT NULL,
    course_id INT NOT NULL,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(id),
    FOREIGN KEY (course_id) REFERENCES Course(id),
    process_score DECIMAL(4,2) CHECK(process_score >= 0),
    final_exam_score DECIMAL(4,2) CHECK(final_exam_score >= 0)
);