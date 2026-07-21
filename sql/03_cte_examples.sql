-- ============================================================
-- 03_cte_examples.sql
-- Part A: Common Table Expressions (CTEs)
-- Five required implementations, each in its own numbered block
-- so it can be run and screenshotted independently.
-- ============================================================


-- ------------------------------------------------------------
-- A.1 SIMPLE CTE
-- Business question: "Give me a clean list of every student
-- together with their department name, without repeating the
-- department lookup logic in multiple places."
-- ------------------------------------------------------------
WITH student_directory AS (
    SELECT
        s.student_id,
        s.first_name || ' ' || s.last_name AS full_name,
        s.email,
        d.department_name
    FROM students s
    JOIN departments d ON d.department_id = s.department_id
)
SELECT *
FROM student_directory
ORDER BY department_name, full_name;


-- ------------------------------------------------------------
-- A.2 MULTIPLE CTEs
-- Business question: "For each department, how many students
-- are enrolled and how many courses does it offer?" Two CTEs
-- are built independently, then combined in the final SELECT.
-- ------------------------------------------------------------
WITH dept_student_counts AS (
    SELECT department_id, COUNT(*) AS student_count
    FROM students
    GROUP BY department_id
),
dept_course_counts AS (
    SELECT department_id, COUNT(*) AS course_count
    FROM courses
    GROUP BY department_id
)
SELECT
    d.department_name,
    NVL(sc.student_count, 0) AS student_count,
    NVL(cc.course_count, 0)  AS course_count
FROM departments d
LEFT JOIN dept_student_counts sc ON sc.department_id = d.department_id
LEFT JOIN dept_course_counts  cc ON cc.department_id = d.department_id
ORDER BY d.department_name;


-- ------------------------------------------------------------
-- A.3 RECURSIVE CTE
-- Business question: "Before a student can take Web Application
-- Development, what is the FULL chain of prerequisite courses,
-- including prerequisites of prerequisites?"
-- ------------------------------------------------------------
WITH prereq_chain (course_id, prerequisite_id, depth) AS (
    -- Anchor member: direct prerequisites of the target course
    SELECT course_id, prerequisite_id, 1 AS depth
    FROM course_prerequisites
    WHERE course_id = 5004   -- Web Application Development

    UNION ALL

    -- Recursive member: prerequisites of the prerequisites
    SELECT cp.course_id, cp.prerequisite_id, pc.depth + 1
    FROM course_prerequisites cp
    JOIN prereq_chain pc ON cp.course_id = pc.prerequisite_id
)
SELECT
    pc.depth,
    c.course_name AS prerequisite_course
FROM prereq_chain pc
JOIN courses c ON c.course_id = pc.prerequisite_id
ORDER BY pc.depth;


-- ------------------------------------------------------------
-- A.4 CTE WITH AGGREGATION
-- Business question: "What is the average GPA earned in each
-- course, and how many students have taken it?" Useful for
-- spotting unusually hard or unusually easy courses.
-- ------------------------------------------------------------
WITH course_performance AS (
    SELECT
        course_id,
        COUNT(*)               AS students_graded,
        ROUND(AVG(grade_point), 2) AS avg_gpa,
        MIN(grade_point)       AS lowest_gpa,
        MAX(grade_point)       AS highest_gpa
    FROM enrollments
    GROUP BY course_id
)
SELECT
    c.course_name,
    cp.students_graded,
    cp.avg_gpa,
    cp.lowest_gpa,
    cp.highest_gpa
FROM course_performance cp
JOIN courses c ON c.course_id = cp.course_id
ORDER BY cp.avg_gpa DESC;


-- ------------------------------------------------------------
-- A.5 CTE COMBINED WITH JOIN
-- Business question: "Rank departments by the total credit-
-- hours their students have completed, so the registrar can
-- see which departments are the most academically active."
-- ------------------------------------------------------------
WITH credit_hours_completed AS (
    SELECT
        s.department_id,
        SUM(c.credits) AS total_credits
    FROM enrollments e
    JOIN students s ON s.student_id = e.student_id
    JOIN courses  c ON c.course_id  = e.course_id
    GROUP BY s.department_id
)
SELECT
    d.department_name,
    chc.total_credits,
    RANK() OVER (ORDER BY chc.total_credits DESC) AS activity_rank
FROM credit_hours_completed chc
JOIN departments d ON d.department_id = chc.department_id
ORDER BY activity_rank;
