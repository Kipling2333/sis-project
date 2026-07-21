-- ============================================================
-- 04_window_functions.sql
-- Part B: SQL Window Functions
-- Four required categories, each in its own numbered block.
-- ============================================================


-- ------------------------------------------------------------
-- B.1 RANKING FUNCTIONS
-- Business question: "Within each course, rank students by the
-- GPA they earned, and show how the four ranking styles differ
-- when there are ties."
-- ------------------------------------------------------------
SELECT
    c.course_name,
    s.first_name || ' ' || s.last_name        AS student_name,
    e.grade_point,
    ROW_NUMBER()   OVER (PARTITION BY e.course_id ORDER BY e.grade_point DESC) AS row_num,
    RANK()         OVER (PARTITION BY e.course_id ORDER BY e.grade_point DESC) AS rank_num,
    DENSE_RANK()   OVER (PARTITION BY e.course_id ORDER BY e.grade_point DESC) AS dense_rank_num,
    ROUND(PERCENT_RANK() OVER (PARTITION BY e.course_id ORDER BY e.grade_point DESC), 2) AS percent_rank_num
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses  c ON c.course_id  = e.course_id
ORDER BY c.course_name, rank_num;


-- ------------------------------------------------------------
-- B.2 AGGREGATE WINDOW FUNCTIONS
-- Business question: "For every enrollment record, show that
-- course's average, minimum, maximum, and running total GPA
-- side-by-side with the individual grade, without collapsing
-- the rows the way GROUP BY would."
-- ------------------------------------------------------------
SELECT
    c.course_name,
    s.first_name || ' ' || s.last_name AS student_name,
    e.grade_point,
    ROUND(AVG(e.grade_point) OVER (PARTITION BY e.course_id), 2) AS course_avg_gpa,
    MIN(e.grade_point) OVER (PARTITION BY e.course_id)           AS course_min_gpa,
    MAX(e.grade_point) OVER (PARTITION BY e.course_id)           AS course_max_gpa,
    SUM(e.grade_point) OVER (PARTITION BY e.course_id)           AS course_sum_gpa
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
JOIN courses  c ON c.course_id  = e.course_id
ORDER BY c.course_name, e.grade_point DESC;


-- ------------------------------------------------------------
-- B.3 NAVIGATION FUNCTIONS (LAG / LEAD)
-- Business question: "For each student, compare this semester's
-- GPA to the GPA they earned in the previous and next semester,
-- to spot improving or declining performance over time."
-- ------------------------------------------------------------
SELECT
    s.first_name || ' ' || s.last_name AS student_name,
    e.semester,
    e.grade_point,
    LAG(e.grade_point)  OVER (PARTITION BY e.student_id ORDER BY e.enrollment_date) AS previous_semester_gpa,
    LEAD(e.grade_point) OVER (PARTITION BY e.student_id ORDER BY e.enrollment_date) AS next_semester_gpa,
    e.grade_point - LAG(e.grade_point) OVER (PARTITION BY e.student_id ORDER BY e.enrollment_date) AS gpa_change
FROM enrollments e
JOIN students s ON s.student_id = e.student_id
ORDER BY student_name, e.enrollment_date;


-- ------------------------------------------------------------
-- B.4 DISTRIBUTION FUNCTIONS (NTILE / CUME_DIST)
-- Business question: "Split all students into four performance
-- quartiles based on their overall average GPA, and show each
-- student's cumulative percentile, to decide who qualifies for
-- the Dean's List or needs academic support."
-- ------------------------------------------------------------
WITH student_avg_gpa AS (
    SELECT
        student_id,
        ROUND(AVG(grade_point), 2) AS avg_gpa
    FROM enrollments
    GROUP BY student_id
)
SELECT
    s.first_name || ' ' || s.last_name AS student_name,
    sag.avg_gpa,
    NTILE(4) OVER (ORDER BY sag.avg_gpa DESC)              AS performance_quartile,
    ROUND(CUME_DIST() OVER (ORDER BY sag.avg_gpa DESC), 2) AS cumulative_percentile
FROM student_avg_gpa sag
JOIN students s ON s.student_id = sag.student_id
ORDER BY sag.avg_gpa DESC;
