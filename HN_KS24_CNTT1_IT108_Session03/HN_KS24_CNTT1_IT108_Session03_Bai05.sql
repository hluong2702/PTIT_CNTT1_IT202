create database Ex05;
use Ex05;

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

create table Score(
student_id int,
subject_id int,
mid_score decimal(4,2) not null check(mid_score >= 0 and mid_score <=10),
final_score decimal(4,2) not null check(final_score >=0 and final_score <=10),
primary key (student_id,subject_id),
foreign key(student_id) references Student(student_id),
foreign key(subject_id) references Subject(subject_id)
);

insert into Student(student_id,full_name,date_of_birth,email) values
('Hoang Cuong Cat','2006-01-25','cat@gmail.com'),
('Hoang Danh','2006-02-27','danh@gmail.com');

insert into Subject(subject_name,credit) values
('java',8),
('data',6);

insert into Score(student_id,subject_id,mid_score,final_score) values
(1,1,7.8,9),
(1,2,9.4,8.9),
(2,1,9.2,9);

update Score
set final_score = 10
where student_id = 1 and subject_id = 1;

select * from Score;
select * from Score where final_score >=8;