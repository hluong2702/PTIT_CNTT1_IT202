create database mini;
use mini;

CREATE TABLE Student (
    student_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Teacher (
    teacher_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Course (
    course_id VARCHAR(10) PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    number_of_sessions INT NOT NULL CHECK (number_of_sessions > 0),
    teacher_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id) ON DELETE CASCADE
);

CREATE TABLE Enrollment (
    student_id VARCHAR(10) NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Course(course_id) ON DELETE CASCADE
);

CREATE TABLE Score (
    student_id VARCHAR(10) NOT NULL,
    course_id VARCHAR(10) NOT NULL,
    midterm_score DECIMAL(4,2) CHECK (midterm_score >= 0 AND midterm_score <= 10),
    final_score DECIMAL(4,2) CHECK (final_score >= 0 AND final_score <= 10),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id, course_id) REFERENCES Enrollment(student_id, course_id) ON DELETE CASCADE
);

USE school;

-- Phần 2 - Thêm dữ liệu
INSERT INTO Student VALUES
    ('SV01', 'Nguyễn Văn A', '2003-05-10', 'a@gmail.com'),
    ('SV02', 'Trần Thị B', '2003-08-15', 'b@gmail.com'),
    ('SV03', 'Lê Văn C', '2002-11-20', 'c@gmail.com'),
    ('SV04', 'Phạm Thị D', '2003-02-12', 'd@gmail.com'),
    ('SV05', 'Hoàng Văn E', '2002-09-30', 'e@gmail.com');

INSERT INTO Teacher VALUES
   ('GV01', 'Nguyễn Minh H', 'h@gmail.com'),
   ('GV02', 'Trần Văn K', 'k@gmail.com'),
   ('GV03', 'Lê Thị M', 'm@gmail.com'),
   ('GV04', 'Phạm Văn N', 'n@gmail.com'),
   ('GV05', 'Hoàng Thị P', 'p@gmail.com');

INSERT INTO Course VALUES
   ('C01', 'Cơ sở dữ liệu', 'Học về SQL và thiết kế CSDL', 30, 'GV01'),
   ('C02', 'Lập trình Java', 'Java cơ bản đến nâng cao', 40, 'GV02'),
   ('C03', 'Cấu trúc dữ liệu', 'Danh sách, Stack, Queue', 35, 'GV03'),
   ('C04', 'Web cơ bản', 'HTML, CSS, JavaScript', 25, 'GV04'),
   ('C05', 'Python cơ bản', 'Python cho người mới', 20, 'GV05');

INSERT INTO Enrollment VALUES
   ('SV01', 'C01', '2025-01-05'),
   ('SV01', 'C02', '2025-01-06'),
   ('SV02', 'C01', '2025-01-07'),
   ('SV03', 'C03', '2025-01-08'),
   ('SV04', 'C04', '2025-01-09');

INSERT INTO Score VALUES
   ('SV01', 'C01', 7.5, 8.0),
   ('SV01', 'C02', 6.5, 7.0),
   ('SV02', 'C01', 8.0, 8.5),
   ('SV03', 'C03', 7.0, 7.5),
   ('SV04', 'C04', 6.0, 6.5);

UPDATE Student
SET email = 'new_email@gmail.com'
WHERE student_id = 'SV01';

UPDATE Course
SET description = 'Khóa học SQL từ cơ bản đến nâng cao'
WHERE course_id = 'C01';

UPDATE Score
SET final_score = 9.0
WHERE student_id = 'SV01' AND course_id = 'C01';

DELETE FROM Enrollment
WHERE student_id = 'SV04' AND course_id = 'C04';

DELETE FROM Score
WHERE student_id = 'SV04' AND course_id = 'C04';

SELECT *
FROM Student;

SELECT *
FROM Teacher;

SELECT *
FROM Course;

SELECT *
FROM Enrollment;

SELECT *
FROM Score;