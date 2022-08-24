-- creating a database with multiple tables for query

CREATE DATABASE IF NOT EXISTS student_courses;
USE student_courses;

-- create the tables

CREATE TABLE IF NOT EXISTS students (
		id INT NOT NULL AUTO_INCREMENT,
        first_name VARCHAR(32),
        last_name VARCHAR(64),
        PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS teachers (
		id INT NOT NULL AUTO_INCREMENT,
        first_name VARCHAR(32),
        last_name VARCHAR(64),
        PRIMARY KEY (id)
);


CREATE TABLE IF NOT EXISTS courses (
		id INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(64),
        teacher_id INT,
        PRIMARY KEY (id),
        FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

CREATE TABLE IF NOT EXISTS student_courses (
		student_id INT NOT NULL,
        course_id INT NOT NULL,
        PRIMARY KEY (student_id, course_id),
        FOREIGN KEY (student_id) REFERENCES students(id),
		FOREIGN KEY (course_id) REFERENCES courses(id)

);

-- insert data into the tables

INSERT INTO students (first_name, last_name) VALUES 
("Roden", "Barba"),
("Airy", "Sponsa"),
("Wori", "Kennigton"),
("Nigel", "Retmeyer"),
("Tyke", "Wellig"),
("Castle", "Bridgeport");

INSERT INTO teachers (first_name, last_name) VALUES 
("Froden", "Maker"),
("Helman", "Haughton"),
("Emilia", "Umaki"),
("Tyliene", "Yearnig");

INSERT INTO courses (name, teacher_id) VALUES 
("Data Science", 1),
("Business Analytics", 2),
("Women's Studies", 3),
("Engineering", 4),
("Art History", 1),
("Computer Graphics", 2);


INSERT INTO student_courses (student_id, course_id) VALUES
(1,7), (2,8), (3,7), (4,9), (5,11), (6,12);

-- queries to see information in all of the tables

select * from students;
select * from courses;
select * from teachers;
select * from student_courses;

-- alter students table adding GPA column and values

ALTER TABLE students 
	ADD COLUMN GPA DECIMAL(2,1) NOT NULL
    AFTER last_name;
    
INSERT INTO students
	(id, GPA)
    VALUES
    (1, 2.1),
    (2, 3.9),
    (3, 3.0),
    (4, 2.7),
    (5, 3.5),
    (6, 2.8)
ON DUPLICATE KEY UPDATE
	GPA = VALUES(GPA);
    
-- alternate method

-- UPDATE students SET GPA = 3.0 
-- WHERE id = 1;
-- UPDATE students SET GPA = 3.9 
-- WHERE id = 2;
-- UPDATE students SET GPA = 2.7 
-- WHERE id = 3;
-- UPDATE students SET GPA = 3.1 
-- WHERE id = 4;
-- UPDATE students SET GPA = 3.3 
-- WHERE id = 5;
-- UPDATE students SET GPA = 2.9 
-- WHERE id = 6;
    
-- query students who's GPA is below average
    
SELECT s.first_name, s.last_name, s.GPA 
FROM students AS s
WHERE GPA < (SELECT AVG(GPA) FROM students);

-- filtering students with the "CASE" query based on GPA

SELECT first_name, last_name, GPA,
  CASE
        WHEN GPA >3.8 THEN 'Outstanding!'
        WHEN GPA >3.4 THEN 'Doing well'
        WHEN GPA >2.9 THEN 'Average'
        WHEN GPA >2.4 THEN 'Needs work'
            ELSE 'Oooof...'
    END AS 'Student_status'
FROM students;

-- query the students and their courses

SELECT s.first_name AS "student_fname", s.last_name AS "student_lname", c.name AS "course_name"
FROM students AS s
JOIN student_courses AS st
ON s.id = st.student_id
JOIN courses AS c
ON c.id = st.course_id
ORDER BY last_name ASC;

-- query the instructors and their courses

SELECT t.first_name AS "instructor_fname", t.last_name AS "instructor_lname", c.name AS "course_name" 
FROM teachers t
LEFT JOIN courses c 
ON c.teacher_id = t.id; 

-- query the students enrolled in data science course and their instructor

SELECT DISTINCT s.first_name AS "student_fname", s.last_name AS "student_lname", 
c.name AS "course_name", t.first_name AS "instructor_fname", t. last_name AS "instructor_lname"
FROM students AS s
JOIN student_courses AS st
ON s.id = st.student_id
JOIN courses AS c
ON c.id = st.course_id
JOIN teachers AS t
ON t.id = c.teacher_id
WHERE c.name = "Data Science";

-- query which course does not have any students enrolled

SELECT c.name AS "course_name"
FROM courses AS c
WHERE c.id NOT IN (SELECT course_id FROM student_courses);

-- query how many students are enrolled in each course

SELECT COUNT(s.id), c.name AS "course_name"
FROM students AS s
JOIN student_courses AS st
ON s.id = st.student_id
JOIN courses AS c
ON c.id = st.course_id
GROUP BY c.name;



