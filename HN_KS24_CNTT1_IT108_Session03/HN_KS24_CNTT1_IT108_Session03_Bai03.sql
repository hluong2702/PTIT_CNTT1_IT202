create database Ex03;
use Ex03;

create table Subject (
subject_id int auto_increment primary key,
subject_name varchar(50),
credit int check(credit >0)
);

insert into Subject(subject_id,subject_name,credit) values
(1,'Toan',3),
(2,'Van',5);

update Subject
set credit = 6
where subject_id =2;

update Subject
set subject_name = 'bibabibo'
where subject_id = 2;

select * from Subject;