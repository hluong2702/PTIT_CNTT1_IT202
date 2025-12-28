CREATE database Ex05;
USE Ex05;

CREATE table Student(
	id int primary key auto_increment UNIQUE,
    name VARCHAR(30) NOT NULL
);

CREATE table Course(
	id int primary key auto_increment UNIQUE,
    name VARCHAR(30) NOT NULL,
    credits INT CHECK(credits >= 0)
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