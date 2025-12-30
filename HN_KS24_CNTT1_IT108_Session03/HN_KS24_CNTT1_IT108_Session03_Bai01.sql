create database Ex01;
use Ex01;

create table Student(
student_id  int auto_increment primary key,
full_name varchar(50) not null,
date_of_birth date,
email varchar(50) unique
);

insert into Student(student_id,full_name,date_of_birth,email) values
('1','Hoang Anh Khoa','1973-12-23','anhkhoa@gmail.com'),
('2','Ngiem Van I','1987-1-21','ngiemi@gmail.com'),
('3','Hoang Xuan Vinh','1988-2-27','xuanvinh@gmail.com');

select * from Student;
select student_id, full_name from Student;
