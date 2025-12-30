create database Ex06;
use Ex06;

create table Student(
student_id int auto_increment primary key,
full_name varchar(50) not null,
date_of_birth date,
email varchar(50) unique
);

create table Subject(
subject_id int auto_increment primary key,
subject_name varchar(50),
credit int check (credit > 0)
);

create table Enrollment(
student_id int not null,
subject_id int not null,
enroll_date date not null,
primary key (student_id,subjetc_id),
foreign key(student_id) references Student(student_id),
foreign key(subject_id) references Subject(subject_id)
);

create table Score(
student_id int not null,
subject_id int not null,
mid_score decimal,
final_score decimal,
primary key (student_id,subjetc_id),
foreign key(student_id) references Student(student_id),
foreign key(subject_id) references Subject(subject_id)
);

INSERT INTO Student (full_name, date_of_birth, email)
VALUES ('Nguyen Van A', '2003-05-10', 'a@gmail.com');
INSERT INTO Subject (subject_name, credit)
VALUES ('Database', 3);
INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES (1, 1, CURDATE());
INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES (1, 1, 7.5, 8.0);
UPDATE Score
SET mid_score = 8.0,
    final_score = 8.5
WHERE student_id = 1 AND subject_id = 1;
DELETE FROM Score
WHERE student_id = 1 AND subject_id = 1;
DELETE FROM Enrollment
WHERE student_id = 1 AND subject_id = 1;
DELETE FROM Student
WHERE student_id = 1;

SELECT s.student_id,s.full_name,sub.subject_name,sc.mid_score,sc.final_score FROM Student s
JOIN Score sc ON s.student_id = sc.student_id
JOIN Subject sub ON sc.subject_id = sub.subject_id;



