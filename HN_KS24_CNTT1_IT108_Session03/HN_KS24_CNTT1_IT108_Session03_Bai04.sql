create database Ex04;
use Ex04;

create table Student(
student_id int auto_increment primary key,
full_name varchar(50) not null,
date_of_birth date,
email varchar(50) unique
);

create table Subject (
subject_id int auto_increment primary key,
subject_name varchar(50),
credit int check(credit >0)
);

create table Enrollment(
student_id int,
subject_id int,
enroll_date date,
primary key(student_id,subject_id),
foreign key(student_id) references Student(student_id),
foreign key(subject_id) references Subject(subject_id)
);

insert into Student(student_id,full_name,date_of_birth,email) values
('Hoang Cuong Cat','2006-01-25','cat@gmail.com'),
('Hoang Danh','2006-02-27','danh@gmail.com');

insert into Subject(subject_name,credit) values
('java',8),
('data',6);

insert into Enrollment(student_id,subject_id,enroll_date) values
(1,1,'2024-01-10'),
(2,1,'2025-02-28');

select * from Enrollment;
select * from Enrollment where student_id= 1;