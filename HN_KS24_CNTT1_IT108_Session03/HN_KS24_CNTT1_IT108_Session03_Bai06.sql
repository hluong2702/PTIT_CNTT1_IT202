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
mid_score decimal(4,2) not null check(mid_score >= 0 and mid_score <=10),
final_score decimal(4,2) not null check(final_score >=0 and final_score <=10),
primary key (student_id,subjetc_id),
foreign key(student_id) references Student(student_id),
foreign key(subject_id) references Subject(subject_id)
);

insert into student (student_id, full_name, date_of_birth, email)
values
(10, 'Nguyen Van A', '2006-10-15', 'nguyenvanf@gmail.com');

insert into subject (subject_id, subject_name, credit)
values 
(1, 'Toan', 3),
(2, 'Van', 3),
(3, 'Anh', 3),
(4, 'Vat ly', 3),
(5, 'Hoa hoc', 3);

insert into enrollment (student_id, subject_id, date)
values
(6, 1, '2024-09-01'),
(6, 3, '2024-09-01');

insert into score (student_id, subject_id, mid_score, final_score)
values
(6, 1, 7.0, 8.0),
(6, 3, 8.0, 9.0);

update score
set final_score = 8.5
where student_id = 6
  and subject_id = 1;

delete from enrollment
where student_id = 6
  and subject_id = 3;

select 
    s.student_id,
    s.full_name,
    sub.subject_name,
    sc.mid_score,
    sc.final_score
from student s
join score sc on s.student_id = sc.student_id
join subject sub on sc.subject_id = sub.subject_id
order by s.student_id;

