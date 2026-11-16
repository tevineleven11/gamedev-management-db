UPDATE bug_t SET employee_id = 'EMP00008' WHERE bug_id = 4;
SELECT bug_id, status, employee_id FROM bug_t WHERE bug_id = 4;

CALL update_task_status_from_logs(12);
SELECT task_id, status FROM task_t WHERE task_id = 12;

CALL update_task_status_from_logs(999);

CALL transfer_task_ownership(7, 'EMP00006', 'EMP00007');
SELECT task_id, employee_id FROM task_t WHERE task_id = 7;

CALL transfer_task_ownership(7, 'EMP00002', 'EMP00003');

UPDATE task_t SET status = 'Completed' WHERE task_id = 13;
SELECT project_id, status, end_date FROM project_t WHERE project_id = 'PRJ03';