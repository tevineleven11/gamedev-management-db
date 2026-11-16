-- queries.sql: example queries for the Vortex Game Studio database
-- Run after schema.sql and seed.sql.

USE vortex_studio;

-- 1. Which tasks are still open, who owns them, and when are they due?
SELECT t.task_id,
       t.description,
       t.status,
       t.due_date,
       CONCAT(e.name, ' ', e.surname) AS assigned_to,
       p.name AS project
FROM task_t t
JOIN employee_t e ON e.employee_id = t.employee_id
JOIN project_t p ON p.project_id = t.project_id
WHERE t.status <> 'Completed'
ORDER BY t.due_date;

-- 2. How many hours has each employee logged, and across how many tasks?
SELECT CONCAT(e.name, ' ', e.surname) AS employee,
       SUM(tl.hours_worked) AS total_hours,
       COUNT(DISTINCT tl.task_id) AS tasks_worked_on
FROM time_log_t tl
JOIN employee_t e ON e.employee_id = tl.employee_id
GROUP BY e.employee_id, e.name, e.surname
ORDER BY total_hours DESC;

-- 3. How many bugs does each game have, broken down by severity?
SELECT g.game_name,
       COUNT(b.bug_id) AS total_bugs,
       SUM(CASE WHEN b.severity = 'Critical' THEN 1 ELSE 0 END) AS critical,
       SUM(CASE WHEN b.severity = 'High'     THEN 1 ELSE 0 END) AS high,
       SUM(CASE WHEN b.severity = 'Medium'   THEN 1 ELSE 0 END) AS medium,
       SUM(CASE WHEN b.severity = 'Low'      THEN 1 ELSE 0 END) AS low
FROM game_t g
LEFT JOIN bug_t b ON b.game_name = g.game_name
GROUP BY g.game_name
ORDER BY total_bugs DESC, g.game_name;

-- 4. Which employees have no tasks assigned?
SELECT e.employee_id,
       CONCAT(e.name, ' ', e.surname) AS employee,
       e.role,
       e.team_name
FROM employee_t e
LEFT JOIN task_t t ON t.employee_id = e.employee_id
WHERE t.task_id IS NULL;

-- 5. Which assets have needed maintenance more than once, and at what total cost?
SELECT a.serial_number,
       a.manufacturer,
       a.model_number,
       a.type,
       COUNT(*) AS maintenance_count,
       SUM(m.cost) AS total_cost
FROM maintenance_t m
JOIN asset_t a ON a.serial_number = m.serial_number
GROUP BY a.serial_number, a.manufacturer, a.model_number, a.type
HAVING COUNT(*) > 1
ORDER BY total_cost DESC;

-- 6. How much of its budget has each project spent?
SELECT p.project_id,
       p.name,
       p.status,
       b.allocated_amount,
       b.spent_amount,
       ROUND(b.spent_amount / NULLIF(b.allocated_amount, 0) * 100, 1) AS pct_spent
FROM project_t p
JOIN budget_t b ON b.project_id = p.project_id
ORDER BY pct_spent DESC;

-- 7. Which campaigns, and which target audiences, earn the best player feedback?
SELECT c.campaign_id,
       c.game_name,
       c.target_audience,
       c.platform,
       COUNT(f.feedback_id) AS feedback_count,
       ROUND(AVG(f.rating), 2) AS avg_rating
FROM marketing_campaign_t c
LEFT JOIN player_feedback_t f ON f.campaign_id = c.campaign_id
GROUP BY c.campaign_id, c.game_name, c.target_audience, c.platform
ORDER BY avg_rating DESC;

-- 8. How do testers rank by the number of bugs they are assigned to? (window function)
SELECT CONCAT(e.name, ' ', e.surname) AS tester,
       COUNT(bt.bug_id) AS bugs_assigned,
       RANK() OVER (ORDER BY COUNT(bt.bug_id) DESC) AS bug_rank
FROM tester_t t
JOIN employee_t e ON e.employee_id = t.employee_id
LEFT JOIN bug_tester_t bt ON bt.employee_id = t.employee_id
GROUP BY e.employee_id, e.name, e.surname
ORDER BY bug_rank;

-- 9. Which employees have reported more than one bug? (correlated subquery)
SELECT CONCAT(e.name, ' ', e.surname) AS employee,
       (SELECT COUNT(*)
        FROM bug_reporter_t br
        WHERE br.employee_id = e.employee_id) AS bugs_reported
FROM employee_t e
WHERE (SELECT COUNT(*)
       FROM bug_reporter_t br
       WHERE br.employee_id = e.employee_id) > 1
ORDER BY e.employee_id;

-- 10. Which developer tasks involved more code than average? (non-correlated subquery)
SELECT t.task_id,
       t.description,
       dt.code_volume
FROM developer_task_t dt
JOIN task_t t ON t.task_id = dt.task_id
WHERE dt.code_volume > (SELECT AVG(code_volume) FROM developer_task_t)
ORDER BY dt.code_volume DESC;

-- 11. Which milestones are still outstanding, and at which meeting were they discussed?
SELECT p.name AS project,
       ms.name AS milestone,
       ms.due_date,
       ms.status,
       mt.date AS discussed_on,
       mt.manager_name AS scheduled_by
FROM milestone_t ms
JOIN project_t p ON p.project_id = ms.project_id
LEFT JOIN meeting_t mt ON mt.meeting_id = ms.meeting_id
WHERE ms.status <> 'Completed'
ORDER BY ms.due_date;

-- 12. Who manages each team, which project is it on, and how many members does it have?
SELECT tm.team_name,
       p.name AS project,
       CONCAT(m.name, ' ', m.surname) AS manager,
       COUNT(e.employee_id) AS members
FROM team_t tm
JOIN project_t p ON p.project_id = tm.project_id
LEFT JOIN employee_t m ON m.employee_id = tm.manager_id
LEFT JOIN employee_t e ON e.team_name = tm.team_name
GROUP BY tm.team_name, p.name, m.name, m.surname
ORDER BY members DESC, tm.team_name;