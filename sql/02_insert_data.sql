-- ============================================================
-- 02_insert_data.sql
-- Sample data for the Student Information System.
-- Run after 01_create_tables.sql has succeeded.
-- ============================================================

-- ------------------------------------------------------------
-- DEPARTMENTS
-- ------------------------------------------------------------
INSERT INTO departments (department_id, department_name, building) VALUES (10, 'Computer Science', 'Block A');
INSERT INTO departments (department_id, department_name, building) VALUES (20, 'Business Administration', 'Block B');
INSERT INTO departments (department_id, department_name, building) VALUES (30, 'Mathematics', 'Block A');
INSERT INTO departments (department_id, department_name, building) VALUES (40, 'Theology', 'Block C');

-- ------------------------------------------------------------
-- INSTRUCTORS
-- ------------------------------------------------------------
INSERT INTO instructors (instructor_id, first_name, last_name, email, department_id) VALUES (101, 'Eric', 'Uwase', 'euwase@unilak.ac.rw', 10);
INSERT INTO instructors (instructor_id, first_name, last_name, email, department_id) VALUES (102, 'Alice', 'Mukamana', 'amukamana@unilak.ac.rw', 10);
INSERT INTO instructors (instructor_id, first_name, last_name, email, department_id) VALUES (103, 'Jean', 'Bosco', 'jbosco@unilak.ac.rw', 20);
INSERT INTO instructors (instructor_id, first_name, last_name, email, department_id) VALUES (104, 'Grace', 'Ingabire', 'gingabire@unilak.ac.rw', 30);
INSERT INTO instructors (instructor_id, first_name, last_name, email, department_id) VALUES (105, 'Paul', 'Nshimiye', 'pnshimiye@unilak.ac.rw', 30);
INSERT INTO instructors (instructor_id, first_name, last_name, email, department_id) VALUES (106, 'Diane', 'Uwimana', 'duwimana@unilak.ac.rw', 40);

-- ------------------------------------------------------------
-- STUDENTS
-- ------------------------------------------------------------
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, department_id) VALUES (1001, 'Kevin', 'Habimana', 'khabimana@student.unilak.ac.rw', DATE '2023-09-04', 10);
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, department_id) VALUES (1002, 'Sandra', 'Umutoni', 'sumutoni@student.unilak.ac.rw', DATE '2023-09-04', 10);
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, department_id) VALUES (1003, 'Eric', 'Niyonsenga', 'eniyonsenga@student.unilak.ac.rw', DATE '2023-09-04', 10);
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, department_id) VALUES (1004, 'Aline', 'Kamikazi', 'akamikazi@student.unilak.ac.rw', DATE '2022-09-05', 20);
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, department_id) VALUES (1005, 'Bruce', 'Ndayisenga', 'bndayisenga@student.unilak.ac.rw', DATE '2022-09-05', 20);
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, department_id) VALUES (1006, 'Chantal', 'Mutesi', 'cmutesi@student.unilak.ac.rw', DATE '2023-09-04', 30);
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, department_id) VALUES (1007, 'Divin', 'Iradukunda', 'diradukunda@student.unilak.ac.rw', DATE '2023-09-04', 30);
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, department_id) VALUES (1008, 'Josiane', 'Uwera', 'juwera@student.unilak.ac.rw', DATE '2021-09-06', 10);
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, department_id) VALUES (1009, 'Fabrice', 'Tuyishime', 'ftuyishime@student.unilak.ac.rw', DATE '2021-09-06', 40);
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, department_id) VALUES (1010, 'Gisele', 'Nyirahabimana', 'gnyirahabimana@student.unilak.ac.rw', DATE '2022-09-05', 40);
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, department_id) VALUES (1011, 'Herve', 'Mugisha', 'hmugisha@student.unilak.ac.rw', DATE '2023-09-04', 20);
INSERT INTO students (student_id, first_name, last_name, email, enrollment_date, department_id) VALUES (1012, 'Immacule', 'Uwimbabazi', 'iuwimbabazi@student.unilak.ac.rw', DATE '2022-09-05', 10);

-- ------------------------------------------------------------
-- COURSES
-- ------------------------------------------------------------
INSERT INTO courses (course_id, course_name, credits, department_id, instructor_id) VALUES (5001, 'Introduction to Programming', 3, 10, 101);
INSERT INTO courses (course_id, course_name, credits, department_id, instructor_id) VALUES (5002, 'Database Programming', 3, 10, 102);
INSERT INTO courses (course_id, course_name, credits, department_id, instructor_id) VALUES (5003, 'Data Structures and Algorithms', 4, 10, 101);
INSERT INTO courses (course_id, course_name, credits, department_id, instructor_id) VALUES (5004, 'Web Application Development', 3, 10, 102);
INSERT INTO courses (course_id, course_name, credits, department_id, instructor_id) VALUES (5005, 'Principles of Management', 3, 20, 103);
INSERT INTO courses (course_id, course_name, credits, department_id, instructor_id) VALUES (5006, 'Financial Accounting', 3, 20, 103);
INSERT INTO courses (course_id, course_name, credits, department_id, instructor_id) VALUES (5007, 'Calculus I', 4, 30, 104);
INSERT INTO courses (course_id, course_name, credits, department_id, instructor_id) VALUES (5008, 'Linear Algebra', 3, 30, 105);
INSERT INTO courses (course_id, course_name, credits, department_id, instructor_id) VALUES (5009, 'Introduction to Theology', 2, 40, 106);
INSERT INTO courses (course_id, course_name, credits, department_id, instructor_id) VALUES (5010, 'Christian Ethics', 2, 40, 106);

-- ------------------------------------------------------------
-- COURSE_PREREQUISITES
-- Introduction to Programming -> required before Data Structures,
-- Database Programming, and Web Application Development.
-- Calculus I -> required before Linear Algebra.
-- Introduction to Theology -> required before Christian Ethics.
-- ------------------------------------------------------------
INSERT INTO course_prerequisites (course_id, prerequisite_id) VALUES (5002, 5001); -- DB Programming needs Intro to Programming
INSERT INTO course_prerequisites (course_id, prerequisite_id) VALUES (5003, 5001); -- Data Structures needs Intro to Programming
INSERT INTO course_prerequisites (course_id, prerequisite_id) VALUES (5004, 5002); -- Web App Dev needs DB Programming
INSERT INTO course_prerequisites (course_id, prerequisite_id) VALUES (5004, 5003); -- Web App Dev also needs Data Structures
INSERT INTO course_prerequisites (course_id, prerequisite_id) VALUES (5008, 5007); -- Linear Algebra needs Calculus I
INSERT INTO course_prerequisites (course_id, prerequisite_id) VALUES (5010, 5009); -- Christian Ethics needs Intro to Theology

-- ------------------------------------------------------------
-- ENROLLMENTS
-- Two semesters of history so window functions (LAG/LEAD, NTILE)
-- have something meaningful to compare.
-- ------------------------------------------------------------
INSERT INTO enrollments VALUES (900001, 1001, 5001, 'Fall 2023', DATE '2023-09-10', 'A',  4.0);
INSERT INTO enrollments VALUES (900002, 1001, 5002, 'Spring 2024', DATE '2024-01-15', 'B+', 3.3);
INSERT INTO enrollments VALUES (900003, 1001, 5003, 'Spring 2024', DATE '2024-01-15', 'A-', 3.7);
INSERT INTO enrollments VALUES (900004, 1002, 5001, 'Fall 2023', DATE '2023-09-10', 'B',  3.0);
INSERT INTO enrollments VALUES (900005, 1002, 5002, 'Spring 2024', DATE '2024-01-15', 'B',  3.0);
INSERT INTO enrollments VALUES (900006, 1003, 5001, 'Fall 2023', DATE '2023-09-10', 'C+', 2.3);
INSERT INTO enrollments VALUES (900007, 1003, 5003, 'Spring 2024', DATE '2024-01-15', 'B-', 2.7);
INSERT INTO enrollments VALUES (900008, 1008, 5001, 'Fall 2021', DATE '2021-09-12', 'A',  4.0);
INSERT INTO enrollments VALUES (900009, 1008, 5002, 'Spring 2022', DATE '2022-01-14', 'A',  4.0);
INSERT INTO enrollments VALUES (900010, 1008, 5004, 'Fall 2022', DATE '2022-09-11', 'A-', 3.7);
INSERT INTO enrollments VALUES (900011, 1012, 5001, 'Fall 2022', DATE '2022-09-11', 'B+', 3.3);
INSERT INTO enrollments VALUES (900012, 1012, 5003, 'Spring 2023', DATE '2023-01-16', 'B',  3.0);
INSERT INTO enrollments VALUES (900013, 1004, 5005, 'Fall 2022', DATE '2022-09-11', 'A-', 3.7);
INSERT INTO enrollments VALUES (900014, 1004, 5006, 'Spring 2023', DATE '2023-01-16', 'B+', 3.3);
INSERT INTO enrollments VALUES (900015, 1005, 5005, 'Fall 2022', DATE '2022-09-11', 'B',  3.0);
INSERT INTO enrollments VALUES (900016, 1005, 5006, 'Spring 2023', DATE '2023-01-16', 'C+', 2.3);
INSERT INTO enrollments VALUES (900017, 1011, 5005, 'Fall 2023', DATE '2023-09-10', 'B-', 2.7);
INSERT INTO enrollments VALUES (900018, 1011, 5006, 'Spring 2024', DATE '2024-01-15', 'B',  3.0);
INSERT INTO enrollments VALUES (900019, 1006, 5007, 'Fall 2023', DATE '2023-09-10', 'A',  4.0);
INSERT INTO enrollments VALUES (900020, 1006, 5008, 'Spring 2024', DATE '2024-01-15', 'A-', 3.7);
INSERT INTO enrollments VALUES (900021, 1007, 5007, 'Fall 2023', DATE '2023-09-10', 'B',  3.0);
INSERT INTO enrollments VALUES (900022, 1007, 5008, 'Spring 2024', DATE '2024-01-15', 'B-', 2.7);
INSERT INTO enrollments VALUES (900023, 1009, 5009, 'Fall 2021', DATE '2021-09-12', 'A',  4.0);
INSERT INTO enrollments VALUES (900024, 1009, 5010, 'Spring 2022', DATE '2022-01-14', 'A',  4.0);
INSERT INTO enrollments VALUES (900025, 1010, 5009, 'Fall 2022', DATE '2022-09-11', 'B+', 3.3);
INSERT INTO enrollments VALUES (900026, 1010, 5010, 'Spring 2023', DATE '2023-01-16', 'A-', 3.7);

COMMIT;
