WITH cls_avg AS (
    SELECT AVG(score) AS class_average
    FROM exam_scores
)
SELECT s.name AS student_name,
    s.branch AS student_branch,
    e.score,
    ca.class_average
FROM exam_scores AS e
    INNER JOIN students AS s ON s.student_id = e.student_id
    CROSS JOIN cls_avg AS ca
WHERE e.score > ca.class_average;


WITH exam_toppers AS(
    SELECT DISTINCT student_id
    FROM exam_scores
    WHERE score >=90
),
project_toppers AS(
    SELECT DISTINCT student_id
    FROM projects 
    WHERE marks >=85
)
SELECT 
    s.student_id,
    s.name,
    s.branch
FROM students AS s 
INNER JOIN exam_toppers AS et ON et.student_id=s.student_id
INNER JOIN project_toppers AS pt ON pt.student_id=s.student_id;
