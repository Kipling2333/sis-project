-- ============================================================
-- 01_create_tables.sql
-- Student Information System (SIS)
-- Creates all tables, primary keys, and foreign keys.
-- Run this AFTER connecting to your PDB as the schema owner
-- (e.g. ALTER SESSION SET CONTAINER = sis_pdb; then connect as SIS_ADMIN).
-- ============================================================

-- Drop tables first in case this script is re-run (safe cleanup)
-- Order matters because of foreign key dependencies.
DROP TABLE enrollments PURGE;
DROP TABLE course_prerequisites PURGE;
DROP TABLE courses PURGE;
DROP TABLE students PURGE;
DROP TABLE instructors PURGE;
DROP TABLE departments PURGE;

-- ------------------------------------------------------------
-- DEPARTMENTS
-- Academic departments that own courses and employ instructors.
-- ------------------------------------------------------------
CREATE TABLE departments (
    department_id    NUMBER(4)       NOT NULL,
    department_name  VARCHAR2(60)    NOT NULL,
    building          VARCHAR2(40),
    CONSTRAINT dept_id_pk PRIMARY KEY (department_id)
);

-- ------------------------------------------------------------
-- INSTRUCTORS
-- Faculty members, each attached to one department.
-- ------------------------------------------------------------
CREATE TABLE instructors (
    instructor_id     NUMBER(6)       NOT NULL,
    first_name        VARCHAR2(30)    NOT NULL,
    last_name         VARCHAR2(30)    NOT NULL,
    email             VARCHAR2(60)    NOT NULL,
    department_id     NUMBER(4)       NOT NULL,
    CONSTRAINT instr_id_pk PRIMARY KEY (instructor_id),
    CONSTRAINT instr_email_uk UNIQUE (email),
    CONSTRAINT instr_dept_fk FOREIGN KEY (department_id)
        REFERENCES departments (department_id)
);

-- ------------------------------------------------------------
-- STUDENTS
-- Each student declares one home department (major).
-- ------------------------------------------------------------
CREATE TABLE students (
    student_id        NUMBER(6)       NOT NULL,
    first_name        VARCHAR2(30)    NOT NULL,
    last_name         VARCHAR2(30)    NOT NULL,
    email             VARCHAR2(60)    NOT NULL,
    enrollment_date   DATE            NOT NULL,
    department_id     NUMBER(4)       NOT NULL,
    CONSTRAINT stud_id_pk PRIMARY KEY (student_id),
    CONSTRAINT stud_email_uk UNIQUE (email),
    CONSTRAINT stud_dept_fk FOREIGN KEY (department_id)
        REFERENCES departments (department_id)
);

-- ------------------------------------------------------------
-- COURSES
-- Each course belongs to one department and is taught by one
-- primary instructor.
-- ------------------------------------------------------------
CREATE TABLE courses (
    course_id         NUMBER(6)       NOT NULL,
    course_name       VARCHAR2(80)    NOT NULL,
    credits           NUMBER(2)       NOT NULL,
    department_id     NUMBER(4)       NOT NULL,
    instructor_id     NUMBER(6),
    CONSTRAINT course_id_pk PRIMARY KEY (course_id),
    CONSTRAINT course_dept_fk FOREIGN KEY (department_id)
        REFERENCES departments (department_id),
    CONSTRAINT course_instr_fk FOREIGN KEY (instructor_id)
        REFERENCES instructors (instructor_id)
);

-- ------------------------------------------------------------
-- COURSE_PREREQUISITES
-- Self-referencing relationship on COURSES: a course can
-- require zero or more other courses to be completed first.
-- This is what makes the recursive CTE (Part A.3) meaningful.
-- ------------------------------------------------------------
CREATE TABLE course_prerequisites (
    course_id         NUMBER(6)       NOT NULL,
    prerequisite_id   NUMBER(6)       NOT NULL,
    CONSTRAINT prereq_pk PRIMARY KEY (course_id, prerequisite_id),
    CONSTRAINT prereq_course_fk FOREIGN KEY (course_id)
        REFERENCES courses (course_id),
    CONSTRAINT prereq_prereq_fk FOREIGN KEY (prerequisite_id)
        REFERENCES courses (course_id),
    CONSTRAINT prereq_not_self CHECK (course_id <> prerequisite_id)
);

-- ------------------------------------------------------------
-- ENROLLMENTS
-- The transactional table: which student took which course,
-- in which semester, and what grade they earned.
-- ------------------------------------------------------------
CREATE TABLE enrollments (
    enrollment_id     NUMBER(8)       NOT NULL,
    student_id        NUMBER(6)       NOT NULL,
    course_id         NUMBER(6)       NOT NULL,
    semester          VARCHAR2(20)    NOT NULL,
    enrollment_date   DATE            NOT NULL,
    letter_grade      VARCHAR2(2),
    grade_point       NUMBER(3,1),
    CONSTRAINT enroll_id_pk PRIMARY KEY (enrollment_id),
    CONSTRAINT enroll_stud_fk FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT enroll_course_fk FOREIGN KEY (course_id)
        REFERENCES courses (course_id),
    CONSTRAINT enroll_gpa_range CHECK (grade_point BETWEEN 0 AND 4)
);

-- Helpful indexes for the foreign keys (Oracle does not index
-- FK columns automatically, unlike primary keys).
CREATE INDEX idx_instr_dept ON instructors (department_id);
CREATE INDEX idx_stud_dept ON students (department_id);
CREATE INDEX idx_course_dept ON courses (department_id);
CREATE INDEX idx_course_instr ON courses (instructor_id);
CREATE INDEX idx_enroll_stud ON enrollments (student_id);
CREATE INDEX idx_enroll_course ON enrollments (course_id);

COMMENT ON TABLE departments IS 'Academic departments';
COMMENT ON TABLE instructors IS 'Faculty members who teach courses';
COMMENT ON TABLE students IS 'Enrolled students and their home department';
COMMENT ON TABLE courses IS 'Courses offered by each department';
COMMENT ON TABLE course_prerequisites IS 'Self-referencing prerequisite chain for courses';
COMMENT ON TABLE enrollments IS 'Fact table: student x course x semester with grade';
