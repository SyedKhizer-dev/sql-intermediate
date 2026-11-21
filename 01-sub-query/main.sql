CREATE TABLE IF NOT EXISTS students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    branch VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS exam_scores (
    score_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES students(student_id),
    subject VARCHAR(30) NOT NULL,
    score INT NOT NULL CHECK (
        score BETWEEN 0 AND 100
    ),
    exam_month VARCHAR(7) NOT NULL
);

CREATE TABLE IF NOT EXISTS projects (
    project_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES students(student_id),
    title VARCHAR(80) NOT NULL,
    marks INT NOT NULL CHECK (
        marks BETWEEN 0 AND 100
    )
);

-- Insert students
INSERT INTO students (name, branch)
VALUES ('Rahul', 'CS'),
    ('Sneha', 'CS'),
    ('Amit', 'IT'),
    ('Priya', 'IT'),
    ('Rohan', 'CS'),
    ('Kavya', 'IT'),
    ('Arjun', 'CS'),
    ('Divya', 'IT');

-- Insert exam scores
INSERT INTO exam_scores (student_id, subject, score, exam_month)
VALUES (1, 'Math', 62, '2024-07'),
    (1, 'SQL', 70, '2024-08'),
    (1, 'Math', 72, '2024-09'),
    (1, 'SQL', 88, '2024-09'),
    (1, 'English', 65, '2024-10'),
    (2, 'Math', 88, '2024-07'),
    (2, 'SQL', 92, '2024-08'),
    (2, 'Math', 91, '2024-09'),
    (2, 'SQL', 95, '2024-09'),
    (2, 'English', 78, '2024-10'),
    (3, 'Math', 48, '2024-07'),
    (3, 'SQL', 55, '2024-08'),
    (3, 'Math', 55, '2024-09'),
    (3, 'SQL', 60, '2024-09'),
    (3, 'English', 70, '2024-10'),
    (4, 'Math', 75, '2024-08'),
    (4, 'SQL', 80, '2024-09'),
    (4, 'SQL', 85, '2024-10'),
    (4, 'English', 90, '2024-10'),
    (6, 'Math', 70, '2024-09'),
    (6, 'SQL', 78, '2024-10'),
    (7, 'Math', 82, '2024-09'),
    (7, 'SQL', 86, '2024-10'),
    (8, 'Math', 68, '2024-09'),
    (8, 'English', 72, '2024-10');

-- Insert projects
INSERT INTO projects (student_id, title, marks)
VALUES (1, 'Todo App in React', 78),
    (2, 'E-commerce API', 96),
    (3, 'Attendance Tracker', 72),
    (4, 'Portfolio Website', 88),
    (6, 'Blog CMS', 81),
    (7, 'Chat App with WebSockets', 90);

-- Q1. Get the student details who has scored more than average score.

SELECT s.student_id,
    s.name,
    s.branch,
    e.subject,
    e.score
FROM exam_scores e
    INNER JOIN students as s ON e.student_id = s.student_id
WHERE e.score >(
        SELECT AVG(score)
        from exam_scores
    );

-- Q2. Criteria for placement
-- 1. At least 1 exam attempt have score >= 90 &
-- 2. Any one of their projects should have marks >= 85

SELECT *
FROM exam_scores
WHERE score >= 90;
SELECT *
FROM projects
WHERE marks >= 85;
SELECT s.student_id,
    s.name,
    s.branch
FROM students as s
WHERE s.student_id IN (
        SELECT student_id
        FROM exam_scores
        WHERE score >= 90
    )
    AND s.student_id IN(
        SELECT student_id
        FROM projects
        WHERE marks >= 85
    );

-- Q3. Requirement:-
-- We need to have total score student has earned and number of exams student has attempted.
-- We also need to have students name and branch in the result

SELECT 
s.name,
s.branch,
total_stats.total_score,
total_stats.number_of_attempts
FROM(
        SELECT 
            e.student_id,
            SUM(e.score) AS total_score,
            COUNT(*) as number_of_attempts
        FROM exam_scores as e
        GROUP BY e.student_id
) as total_stats
INNER JOIN students as s ON s.student_id=total_stats.student_id;

-- Q4. Requirement(Sub query using joins):-
-- For each project get students name, branch, project marks
-- also their avg exam score on the same row

SELECT 
    s.name,
    s.branch,
    p.title,
    p.marks
FROM projects as p
INNER JOIN students as s
ON s.student_id=p.student_id
INNER JOIN(
    SELECT 
        student_id,
        AVG(score) as average_score
    FROM exam_scores 
    GROUP BY student_id
)as exam_avg ON exam_avg.student_id=p.student_id;