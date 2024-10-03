CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(25) NOT NULL,
    enabled BOOLEAN DEFAULT TRUE,
    last_login TIMESTAMP DEFAULT NOW ()
);
drop table users;

insert into users values('John Smith', True); 
insert into users (id, enabled) values(3, False);
insert into users (id, full_name, enabled) values (1, 'Alissa Jackson', True);
UPDATE users 
SET 
    users.id = NULL
WHERE
    users.id = 2;
DELETE FROM users 
WHERE
    full_name = 'john smith';

CREATE TABLE Artists (
    artist_id INT PRIMARY KEY AUTO_INCREMENT,
    artist_name VARCHAR(25) NOT NULL
);
insert into Artists values (1, "Journey");
insert into Artists values (2, "Meat Loaf");
insert into Artists values (3, "Enya");
insert into Artists values (4, "Kate Wolf");
insert into Artists values (5, "Aerosmith");


CREATE TABLE Albums (
    album_id INT PRIMARY KEY AUTO_INCREMENT,
    artist_id INT NOT NULL,
    album_name VARCHAR(25) NOT NULL,
    FOREIGN KEY (artist_id)
        REFERENCES Artists (artist_id)
);
drop table albums;

insert into albums (artist_id, album_name) values (1, "Raised on Radio");
insert into albums (artist_id, album_name) values (1, "Geatest Hits");
insert into albums (artist_id, album_name) values (2, "Bat out of Hell");
insert into albums (artist_id, album_name) values (2, "Dead Ringer");
insert into albums (artist_id, album_name) values (3, "The Celts");
insert into albums (artist_id, album_name) values (4, "Poet's Heart");

SELECT 
    *
FROM
    albums
        INNER JOIN
    artists ON albums.artist_id = Artists.artist_id;
SELECT 
    *
FROM
    artists
        LEFT OUTER JOIN
    albums ON artists.artist_id = albums.artist_id;
SELECT 
    *
FROM
    artists
        RIGHT OUTER JOIN
    albums ON artists.artist_id = albums.artist_id;

SELECT 
    *
FROM
    artists
        LEFT OUTER JOIN
    albums ON albums.artist_id = NULL 
UNION SELECT 
    *
FROM
    artists
        RIGHT OUTER JOIN
    albums ON artists.artist_id = NULL;



CREATE TABLE Drivers (
    id 				INT PRIMARY KEY AUTO_INCREMENT,
    first_name 		VARCHAR(25) NOT NULL,
    last_name 		VARCHAR(25) NOT NULL,
    phone_number 	VARCHAR(25) NOT NULL
);


CREATE TABLE Cars (
    id 				INT PRIMARY KEY AUTO_INCREMENT,
    color 			VARCHAR(25) NOT NULL,
    model 			VARCHAR(25) NOT NULL,
    plate_number 	VARCHAR(25) NOT NULL UNIQUE,
    driver_id 		INT NOT NULL,
    FOREIGN KEY (driver_id)
        REFERENCES Drivers (id)
);


CREATE TABLE Passengers (
    id 				INT PRIMARY KEY AUTO_INCREMENT,
    first_name 		VARCHAR(25) NOT NULL,
    last_name 		VARCHAR(25) NOT NULL,
    phone_number 	VARCHAR(25) NOT NULL,
    created_at 		DATE
);

CREATE TABLE Rides (
    passenger_id 		INT AUTO_INCREMENT,
    driver_id			INT NOT NULL,
    car_id 				INT NOT NULL,
    origin_lat 			VARCHAR(25) NOT NULL,
    origin_lng 			VARCHAR(25) NOT NULL,
    destination_lat		VARCHAR(25) NOT NULL,
    destination_lng 	VARCHAR(25) NOT NULL,
    ride_status 		VARCHAR(25) NOT NULL,
    created_at			DATE,
    foreign key (passenger_id) references Passengers(id),
    foreign key (driver_id) references Drivers(id),
    foreign key (car_id) references Cars(id),
    primary key (passenger_id, driver_id, car_id)
);

#A
SELECT 
    dept_name, SUM(salary) AS sum_sal
FROM
    instructor
GROUP BY dept_name;
#B
SELECT 
    *
FROM
    instructor
WHERE
    dept_name = 'physics'
        AND salary BETWEEN 45000 AND 100000
ORDER BY salary ASC;
#C
with dept_salary as (select dept_name, sum(salary) as sum_sal from instructor group by dept_name) 
select dept_name from dept_salary where sum_sal > 120000;
#D
SELECT 
    *
FROM
    course
WHERE
    title LIKE 'CS-1%';



insert into instructor values ('10211', 'Smith', 'Biology', 66000);
delete from student where name='jafar' ;
drop table student ;
alter table student drop family_name;
alter table student add post_number INT not null ;
select distinct dept_name, count(dept_name) from instructor;
select all dept_name, count(dept_name) from instructor;
select '436' as FOO;
select ID, name, (salary/12 + 1) as monthly_salary from instructor;
select distinct T.name from instructor as T, instructor as S where T.salary > S.salary and S.dept_name = 'Comp. Sci.';
select name from instructor where name like "____%";
select name from instructor where name like "\%";
select name from instructor where name like '___' order by name desc;
select name, course_id from instructor, teaches where (instructor.ID, dept_name) = (teaches.ID, 'Biology');
select name from instructor where salary between 90000 and 100000;
(select course_id from section where semester='Fall' and year=2009)
union
(select course_id from section where semester='Spring' and year=2002);
select * from section;
#(select course_id from section where semester='Fall' and year=2009) except
#(select course_id from section where semester='Spring' and year=2002);

#(select course_id from section where semester='Fall' and year=2009) intersect
#(select course_id from section where semester='Spring' and year=2002);

select name from instructor where salary is null;
select (null = null); # result is unknown
select count(distinct ID) from teaches where semester = 'Spring' and year = 2002;
select count(*) from course;
select dept_name, avg(salary) as avg_salary from instructor group by dept_name;
select dept_name, avg(salary) as avg_salary from instructor group by dept_name having avg_salary > 75000;
select dept_name, ID, avg(salary) from instructor group by dept_name, ID;
select dept_name, ID, avg(salary) from instructor group by dept_name; # error
select distinct course_id from section where semester='Fall' and year=2004 and course_id in 
			(select course_id from section where semester='Spring' and year= 2002);
select distinct name from instructor where name not in ('Motzart', 'Einstein');
select count(distinct ID) from takes where (course_id, sec_id, semester, year) in
			(select course_id, sec_id, semester, year from teaches where teaches.ID = 10101);
select salary from instructor where dept_name='Biology';
select name from instructor where salary > some (select salary from instructor where dept_name='Biology');
select name from instructor where salary > all (select salary from instructor where dept_name='Biology');
select course_id from section as S where semester='Fall' and year=2000 and exists
	(select * from section as T where semester='Spring' and year=2004 and S.course_id=T.course_id);
#select T.course_id from course as T where unique ( select R.course_id from course as R where T.course_id = R.course_id and R.year = 2017);
select dept_name, avg_salary from 
	(select dept_name, avg(salary) as avg_salary from instructor group by dept_name) T where avg_salary > 42000;
with max_budget(value) as (select max(budget) from department)
select dept_name from department, max_budget where budget = value;
with dept_total(dept_name, value) as (select dept_name, sum(salary) as value from instructor group by dept_name),
	dept_total_avg(value2) as (select avg(value) value2 from dept_total)
select dept_name from dept_total, dept_total_avg where value > value2;

with dept_total(dept_name, value) as (select dept_name, sum(salary) as value from instructor group by dept_name)
select dept_name from dept_total, (select avg(value) average from dept_total) someT where value > average;

select dept_name, (select count(*) from instructor S where S.dept_name=T.dept_name) instructor_count from department T;
delete from instructor where dept_name in (select dept_name from department where building='Watsonz');
with summ(value) as (select max(salary) from instructor) 
delete from instructor where salary > (select value from summ);
insert into temp_table select * from instrcutor;

with aver(value) as (select avg(salary) from instructor)
update instructor set salary = salary * 1 where salary < (select value from aver);

delete from instructor where salary < (select min(salary) from instructor); # this wont work accessing and changing instructor at the same time is not possible
update instructor set salary = case 
									when salary <= 100000 then salary * 1.05
                                    when salary <= 100000 then salary * 1.01
                                    else salary * 1.03
								end;
SELECT COALESCE(NULL, NULL, NULL, 'W3Schools.com', NULL, 'Example.com');
create view v as ( select coalesce(NULL, 'something', 'somehting else') );
select * from v;
drop view v;
# chapter 4 
select name, course_id from student, takes where student.ID = takes.ID;
select name, course_id from student natural join takes;
select name, course_id from student inner join takes on student.ID = takes.ID;
select name, course_id from student natural left outer join takes;
select name, course_id from student natural right outer join takes;
select name, x.ID from student, (select ID from takes where ID like '3%') x;


select * from student, takes where student.ID = takes.ID;
select * from student natural join takes;
select * from student inner join takes on student.ID = takes.ID;
select * from student left outer join takes on takes.ID = student.ID;
select * from student natural right outer join takes;


create table x (
	x_id INT,
    z_id INT NOT NULL,
    name varchar(20) not null,
    primary key (x_id),
    check (x_id < 10)
);
drop table x;

create table z (
	z_id INT auto_increment,
	x_id INT NOT NULL,
    primary key (z_id) 
);
insert into x values (2, 1, "armin");
insert into x values (4, 2, "amin");
insert into x values (12, 2, "an");
insert into z values (1, 2);
insert into z values (3, 3);
insert into z values (4, 4);
insert into z values (5, 5);
select * from x right outer join z on x.x_id = z.x_id and z.z_id = x.z_id;
select * from x natural right outer join z;
select * from course left outer join prereq on course.course_id = prereq.course_id;
select * from course;
create view department_total_salary(dept_name, total_salary) as 
	select dept_name, sum(salary)
    from instructor
    group by dept_name;
select * from department_total_salary;

insert into department_total_salary values("Elahiat", 10000000);
drop view department_total_salary;
#create type dollors as numeric(12, 2) final;

create role U;
grant delete on instructor to U;
revoke update on instructor from U;
grant U to amit;

select * from instructor limit 5;
create index instructorID_index on instructor(ID);
create index somename on instructor(ID);

# create domain person_name char(20) not null;
# create type person_name char(20);
# blob and clob return a pointer rather than the large object it self
# create assertion s1 check (name in ('winter', 'fall', 'spring'))
# create assertion s2 check (x < 20)
# primary key (course_id, sec_id, semester, year)
# foreign key (dept_name) references department(dept_name)
# unique(A1, ..., An) states that (A1, ... ,An) forms a candidate key
# integrity constraints (x > 100 , x in (sad, happy, low), non null, unique, ...)
Delimiter //
CREATE PROCEDURE p (divisor INT)
BEGIN
  DECLARE my_error CONDITION FOR SQLSTATE '45000';
  IF divisor = 0 THEN
    BEGIN
      DECLARE my_error CONDITION FOR SQLSTATE '22012';
      SIGNAL my_error;
    END;
  END IF;
  SIGNAL my_error;
END; //

