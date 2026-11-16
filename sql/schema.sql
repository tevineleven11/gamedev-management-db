DROP DATABASE IF EXISTS vortex_studio;
CREATE DATABASE vortex_studio;
USE vortex_studio;

CREATE TABLE budget_t (   
    budget_id VARCHAR(5) NOT NULL,
    allocated_amount DECIMAL(10,2) DEFAULT 0.00,
    spent_amount DECIMAL(10,2) DEFAULT 0.00,
    remaining_amount DECIMAL(10,2) DEFAULT 0.00,
    CONSTRAINT budget_id_chk CHECK (LENGTH(budget_id) = 5),
    CONSTRAINT allocated_amount_chk CHECK (allocated_amount >= 0),
    CONSTRAINT spent_amount_chk CHECK (spent_amount >= 0),
    CONSTRAINT remaining_amount_chk CHECK (remaining_amount >= 0),
    CONSTRAINT budget_balance_chk CHECK (allocated_amount >= spent_amount),
    CONSTRAINT budget_t_pk PRIMARY KEY(budget_id)
);

CREATE TABLE project_t (
    project_id VARCHAR(5) NOT NULL,
    name VARCHAR(50) DEFAULT 'New Project',
    start_date DATE DEFAULT (CURRENT_DATE),
    end_date DATE DEFAULT (CURRENT_DATE + INTERVAL 6 MONTH),
    budget DECIMAL(10,2) DEFAULT 100000.00,
    status VARCHAR(20) DEFAULT 'Planning',
    CONSTRAINT project_id_chk CHECK (LENGTH(project_id) = 5),
    CONSTRAINT name_chk CHECK (LENGTH(name) BETWEEN 2 AND 50),
    CONSTRAINT end_date_chk CHECK (end_date > start_date),
    CONSTRAINT budget_chk CHECK (budget BETWEEN 1000.00 AND 1000000.00),
    CONSTRAINT project_status_chk CHECK (status IN ('Planning', 'Active', 'Completed', 'Cancelled')),
    CONSTRAINT project_t_pk PRIMARY KEY(project_id)
);

CREATE TABLE team_t (
    team_name VARCHAR(30) NOT NULL,
    team_size INT DEFAULT 5,
    project_id VARCHAR(10),
    CONSTRAINT team_name_chk CHECK (LENGTH(team_name) >= 3),
    CONSTRAINT team_size_chk CHECK (team_size BETWEEN 5 AND 20),
    CONSTRAINT team_t_pk PRIMARY KEY(team_name),
    CONSTRAINT team_t_fk FOREIGN KEY (project_id) REFERENCES project_t(project_id)
);


CREATE TABLE employee_t (
    employee_id VARCHAR(8) NOT NULL,
    name VARCHAR(25),
    surname VARCHAR(25),
    id_number VARCHAR(13) DEFAULT '0000000000000',
    email VARCHAR(100),
    experience_level VARCHAR(20) DEFAULT 'Junior',
    role VARCHAR(30) DEFAULT 'Developer',
    team_name VARCHAR(30),
    CONSTRAINT employee_id_chk CHECK (LENGTH(employee_id) = 8),
    CONSTRAINT id_number_chk CHECK (LENGTH(id_number) = 13),
    CONSTRAINT email_chk CHECK (email LIKE '%@%.%'),
    CONSTRAINT experience_chk CHECK (experience_level IN ('Junior', 'Mid', 'Senior')),
    CONSTRAINT role_chk CHECK (role IN ('Developer', 'Tester', 'Manager')),
    CONSTRAINT employee_t_pk PRIMARY KEY(employee_id),
    CONSTRAINT employee_t_fk FOREIGN KEY (team_name) REFERENCES team_t(team_name)
);

CREATE TABLE developer_t (
    employee_id VARCHAR(8) NOT NULL,
    programming_language VARCHAR(30) DEFAULT 'JavaScript',
    tool VARCHAR(30) DEFAULT 'VS Code',
    CONSTRAINT programming_language_chk CHECK (programming_language IN ('JavaScript', 'Python', 'Java', 'C#', 'C++', 'PHP')),
    CONSTRAINT developer_tool_chk CHECK (tool IN ('VS Code', 'IntelliJ', 'Eclipse', 'PyCharm', 'NetBeans')),
    CONSTRAINT developer_t_pk PRIMARY KEY(employee_id),
    CONSTRAINT developer_t_fk FOREIGN KEY (employee_id) REFERENCES employee_t(employee_id)
);

CREATE TABLE tester_t (
    employee_id VARCHAR(8) NOT NULL,
    testing_type VARCHAR(30) DEFAULT 'Manual',
    tool VARCHAR(30) DEFAULT 'Bugzilla',
    CONSTRAINT testing_type_chk CHECK (testing_type IN ('Manual', 'Automated')),
    CONSTRAINT tester_tool_chk CHECK (tool IN ('Selenium', 'JIRA', 'Bugzilla', 'TestRail', 'JMeter')),
    CONSTRAINT tester_t_pk PRIMARY KEY(employee_id),
    CONSTRAINT tester_t_fk FOREIGN KEY (employee_id) REFERENCES employee_t(employee_id)
);

CREATE TABLE manager_t (
    employee_id VARCHAR(8) NOT NULL,
    management_style VARCHAR(30) DEFAULT 'Democratic',
    employee_satisfaction INT DEFAULT 75,
    CONSTRAINT satisfaction_chk CHECK (employee_satisfaction BETWEEN 0 AND 100),
    CONSTRAINT manager_style_chk CHECK (management_style IN ('Democratic', 'Autocratic', 'Laissez-faire', 'Transformational')),
    CONSTRAINT manager_t_pk PRIMARY KEY(employee_id),
    CONSTRAINT manager_t_fk FOREIGN KEY (employee_id) REFERENCES employee_t(employee_id)
);

CREATE TABLE task_t (
    task_id INT NOT NULL AUTO_INCREMENT,
    description TEXT,
    due_date DATE DEFAULT (CURRENT_DATE + INTERVAL 7 DAY),
    status VARCHAR(20) DEFAULT 'Pending',
    type VARCHAR(20) DEFAULT 'Developer',
    employee_id VARCHAR(10),
    project_id VARCHAR(10),
    CONSTRAINT task_status_chk CHECK (status IN ('Pending', 'In Progress', 'Completed', 'Blocked')),
    CONSTRAINT task_type_chk CHECK (type IN ('Developer', 'Tester', 'Manager')),
    CONSTRAINT task_t_pk PRIMARY KEY(task_id),
    CONSTRAINT task_t_fk1 FOREIGN KEY (employee_id) REFERENCES employee_t(employee_id),
    CONSTRAINT task_t_fk2 FOREIGN KEY (project_id) REFERENCES project_t(project_id)
);

CREATE TABLE developer_task_t (
    task_id INT NOT NULL,
    code_volume INT DEFAULT 0,
    documented BOOLEAN DEFAULT FALSE,
    CONSTRAINT code_volume_chk CHECK (code_volume BETWEEN 0 AND 100000),
    CONSTRAINT developer_task_t_pk PRIMARY KEY(task_id),
    CONSTRAINT developer_task_t_fk FOREIGN KEY (task_id) REFERENCES task_t(task_id)
);

CREATE TABLE tester_task_t (
    task_id INT NOT NULL,
    execution_time DECIMAL(5,2) DEFAULT 0.00,
    coverage INT DEFAULT 0,
    CONSTRAINT coverage_chk CHECK (coverage BETWEEN 0 AND 100), 
    CONSTRAINT tester_task_t_pk PRIMARY KEY(task_id),
    CONSTRAINT tester_task_t_fk FOREIGN KEY (task_id) REFERENCES task_t(task_id)
);

CREATE TABLE manager_task_t (
    task_id INT NOT NULL,
    information_discussed VARCHAR(100),
    session_outcome VARCHAR(30) DEFAULT 'Resolved',
    CONSTRAINT session_outcome_chk CHECK (session_outcome IN ('Resolved', 'Pending', 'Escalated')),
    CONSTRAINT manager_task_t_pk PRIMARY KEY(task_id),
    CONSTRAINT manager_task_t_fk FOREIGN KEY (task_id) REFERENCES task_t(task_id)
);

CREATE TABLE project_asset_t (
    project_id VARCHAR(10) NOT NULL,
    asset_id VARCHAR(10) NOT NULL,
    CONSTRAINT project_asset_t_pk PRIMARY KEY(project_id, asset_id),
    CONSTRAINT project_asset_t_fk FOREIGN KEY (project_id) REFERENCES project_t(project_id)
);

CREATE TABLE meeting_t (
    meeting_id VARCHAR(5) NOT NULL,
    agenda TEXT,
    date DATE DEFAULT (CURRENT_DATE),
    manager_name VARCHAR(30),
    employee_id VARCHAR(10),
    CONSTRAINT meeting_id_chk CHECK (LENGTH(meeting_id) = 5),
    CONSTRAINT meeting_t_pk PRIMARY KEY(meeting_id),
    CONSTRAINT meeting_t_fk FOREIGN KEY (employee_id) REFERENCES employee_t(employee_id)
);

CREATE TABLE milestone_t (
    milestone_id VARCHAR(5) NOT NULL,
    name VARCHAR(50),
    due_date DATE DEFAULT (CURRENT_DATE + INTERVAL 30 DAY),
    status VARCHAR(20) DEFAULT 'Scheduled',
    meeting_id VARCHAR(10),
    CONSTRAINT milestone_id_chk CHECK (LENGTH(milestone_id) = 5),
    CONSTRAINT meeting_status_chk CHECK (status IN ('Scheduled', 'In Progress', 'Completed', 'Cancelled')),
    CONSTRAINT milestone_t_pk PRIMARY KEY(milestone_id),
    CONSTRAINT milestone_t_fk FOREIGN KEY (meeting_id) REFERENCES meeting_t(meeting_id)
);

CREATE TABLE time_log_t (
    log_id VARCHAR(5) NOT NULL,
    log_date DATE DEFAULT (CURRENT_DATE),
    hours_worked INT DEFAULT 0,
    employee VARCHAR(50),
    task_id INT NOT NULL,
    employee_id VARCHAR(10),
    CONSTRAINT log_id_chk CHECK (LENGTH(log_id) = 5),
    CONSTRAINT hours_worked_chk CHECK (hours_worked BETWEEN 0 AND 24),
    CONSTRAINT time_log_t_pk PRIMARY KEY(log_id),
    CONSTRAINT time_log_t_fk1 FOREIGN KEY (task_id) REFERENCES task_t(task_id),
    CONSTRAINT time_log_t_fk2 FOREIGN KEY (employee_id) REFERENCES employee_t(employee_id)
);

CREATE TABLE game_t (
    game_name VARCHAR(50) NOT NULL,
    genre VARCHAR(30),
    platform VARCHAR(30),
    project_id VARCHAR(10),
    CONSTRAINT genre_chk CHECK (genre IN ('Action', 'Adventure', 'RPG', 'Strategy', 'Simulation', 'Sports')),
    CONSTRAINT game_platform_chk CHECK (platform IN ('PC', 'Console', 'Mobile', 'VR')),
    CONSTRAINT game_t_pk PRIMARY KEY(game_name),
    CONSTRAINT game_t_fk FOREIGN KEY (project_id) REFERENCES project_t(project_id)
);

CREATE TABLE bug_t (
    bug_id INT NOT NULL AUTO_INCREMENT,
    description TEXT,
    severity VARCHAR(20) DEFAULT 'Low',
    status VARCHAR(20) DEFAULT 'Reported',
    employee_id VARCHAR(10),
    CONSTRAINT severity_chk CHECK (severity IN ('Low', 'Medium', 'High', 'Critical')),
    CONSTRAINT status_chk CHECK (status IN ('Reported', 'In Progress', 'Fixed', 'Wont Fix')),
    CONSTRAINT bug_t_pk PRIMARY KEY(bug_id),
    CONSTRAINT bug_t_fk FOREIGN KEY (employee_id) REFERENCES employee_t(employee_id)
);

CREATE TABLE bug_reporter_t (
    bug_id INT NOT NULL,
    developer_name VARCHAR(50),
    employee_id VARCHAR(10) NOT NULL,
    CONSTRAINT bug_reporter_t_pk PRIMARY KEY(bug_id, employee_id),
    CONSTRAINT bug_reporter_t_fk1 FOREIGN KEY (bug_id) REFERENCES bug_t(bug_id),
    CONSTRAINT bug_reporter_t_fk2 FOREIGN KEY (employee_id) REFERENCES employee_t(employee_id)
);

CREATE TABLE bug_tester_t (
    bug_id INT NOT NULL,
    tester_name VARCHAR(50),
    employee_id VARCHAR(10) NOT NULL,
    CONSTRAINT bug_tester_t_pk PRIMARY KEY(bug_id, employee_id),
    CONSTRAINT bug_tester_t_fk1 FOREIGN KEY (bug_id) REFERENCES bug_t(bug_id),
    CONSTRAINT bug_tester_t_fk2 FOREIGN KEY (employee_id) REFERENCES employee_t(employee_id)
);

CREATE TABLE asset_t (
    serial_number VARCHAR(20) NOT NULL,
    manufacturer VARCHAR(50),
    model_number VARCHAR(30),
    purchase_date DATE DEFAULT (CURRENT_DATE),
    item_condition VARCHAR(20) DEFAULT 'New',
    type VARCHAR(30) DEFAULT 'Hardware',
    CONSTRAINT condition_chk CHECK (item_condition IN ('New', 'Good', 'Fair', 'Poor')),
    CONSTRAINT asset_type_chk CHECK (type IN ('Hardware', 'Testing', 'Server')),
    CONSTRAINT asset_t_pk PRIMARY KEY(serial_number)
);

CREATE TABLE hardware_asset_t (
    serial_number VARCHAR(20) NOT NULL,
    equipment_type VARCHAR(30) DEFAULT 'Computer',
    connectivity_type VARCHAR(30) DEFAULT 'Wired',
    CONSTRAINT equipment_type_chk CHECK (equipment_type IN ('Computer', 'Laptop', 'Monitor', 'Printer')),
    CONSTRAINT connectivity_type_chk CHECK (connectivity_type IN ('Wired', 'Wireless')),
    CONSTRAINT hardware_asset_t_pk PRIMARY KEY(serial_number),
    CONSTRAINT hardware_asset_t_fk FOREIGN KEY (serial_number) REFERENCES asset_t(serial_number)
);

CREATE TABLE testing_device_t (
    serial_number VARCHAR(20) NOT NULL,
    device_type VARCHAR(30) DEFAULT 'Mobile',
    platform VARCHAR(30) DEFAULT 'Android',
    firmware_version VARCHAR(30) DEFAULT '1.0',
     CONSTRAINT testing_device_type_chk CHECK (device_type IN ('Mobile', 'Tablet', 'Console')),
    CONSTRAINT testing_device_platform_chk CHECK (platform IN ('Android', 'iOS', 'Windows', 'PlayStation', 'Xbox')),
    CONSTRAINT testing_device_t_pk PRIMARY KEY(serial_number),
    CONSTRAINT testing_device_t_fk FOREIGN KEY (serial_number) REFERENCES asset_t(serial_number)
);

CREATE TABLE server_asset_t (
    serial_number VARCHAR(20) NOT NULL,
    server_type VARCHAR(30) DEFAULT 'Database',
    storage_capacity VARCHAR(30) DEFAULT '10TB',
    ip_address VARCHAR(30) DEFAULT '192.168.1.1',
    game_name VARCHAR(50) DEFAULT 'Untitled Game',
    CONSTRAINT server_type_chk CHECK (server_type IN ('Database', 'Web', 'Application')),
    CONSTRAINT server_asset_t_pk PRIMARY KEY(serial_number),
    CONSTRAINT server_asset_t_fk1 FOREIGN KEY (serial_number) REFERENCES asset_t(serial_number),
    CONSTRAINT server_asset_t_fk2 FOREIGN KEY (game_name) REFERENCES game_t(game_name)
);

CREATE TABLE maintenance_provider_t (
    provider_id VARCHAR(6) NOT NULL,
    company_name VARCHAR(50),
    contact_person VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(20) DEFAULT '000-000-0000',
    CONSTRAINT provider_id_chk CHECK (LENGTH(provider_id) = 6),
    CONSTRAINT maintenance_provider_t_pk PRIMARY KEY(provider_id)
);

CREATE TABLE maintenance_t (
    maintenance_id INT NOT NULL AUTO_INCREMENT,
    description TEXT,
    date DATE DEFAULT (CURRENT_DATE),
    cost DECIMAL(10,2) DEFAULT 0.00,
    provider VARCHAR(50),
    serial_number VARCHAR(20),
    provider_id VARCHAR(10),
    CONSTRAINT cost_chk CHECK (cost >= 0),
    CONSTRAINT serial_number_chk CHECK (LENGTH(serial_number) = 20),
    CONSTRAINT maintenance_t_pk PRIMARY KEY(maintenance_id),
    CONSTRAINT maintenance_t_fk1 FOREIGN KEY (serial_number) REFERENCES asset_t(serial_number),
    CONSTRAINT maintenance_t_fk2 FOREIGN KEY (provider_id) REFERENCES maintenance_provider_t(provider_id)
);

CREATE TABLE marketing_campaign_t (
    campaign_id INT NOT NULL AUTO_INCREMENT,
    start_date DATE DEFAULT (CURRENT_DATE),
    end_date DATE DEFAULT (CURRENT_DATE + INTERVAL 1 MONTH),
    target_audience VARCHAR(30) DEFAULT 'Casual Players',
    platform VARCHAR(30) DEFAULT 'Social Media',
    game_name VARCHAR(50),
    CONSTRAINT audience_chk CHECK (target_audience IN ('Casual Players', 'Hardcore Gamers', 'Kids', 'Teens','All Ages')),
    CONSTRAINT campaign_platform_chk CHECK (platform IN ('Social Media', 'TV', 'Online Ads', 'Influencers')),
    CONSTRAINT marketing_campaign_t_pk PRIMARY KEY(campaign_id),
    CONSTRAINT marketing_campaign_t_fk FOREIGN KEY (game_name) REFERENCES game_t(game_name)
);

CREATE TABLE player_feedback_t (
    feedback_id INT NOT NULL AUTO_INCREMENT,
    date DATE DEFAULT (CURRENT_DATE),
    rating DECIMAL(3,2) DEFAULT 3.00,
    description TEXT,
    campaign_id INT NOT NULL,
    CONSTRAINT rating_chk CHECK (rating BETWEEN 0.00 AND 5.00),
    CONSTRAINT player_feedback_t_pk PRIMARY KEY(feedback_id),
    CONSTRAINT player_feedback_t_fk FOREIGN KEY (campaign_id) REFERENCES marketing_campaign_t(campaign_id)
);

#Relationships from the business scenario

# a budget is assigned to exactly one project
ALTER TABLE budget_t
    ADD COLUMN project_id VARCHAR(5) NOT NULL,
    ADD CONSTRAINT budget_project_uq UNIQUE (project_id),
    ADD CONSTRAINT budget_t_fk FOREIGN KEY (project_id) REFERENCES project_t(project_id);

# a team is managed by one manager, and a manager manages one team
ALTER TABLE team_t
    ADD COLUMN manager_id VARCHAR(8),
    ADD CONSTRAINT team_manager_uq UNIQUE (manager_id),
    ADD CONSTRAINT team_t_fk2 FOREIGN KEY (manager_id) REFERENCES manager_t(employee_id);

# a meeting is organised for one team
ALTER TABLE meeting_t
    ADD COLUMN team_name VARCHAR(30),
    ADD CONSTRAINT meeting_t_fk2 FOREIGN KEY (team_name) REFERENCES team_t(team_name);

# each milestone belongs to one project
ALTER TABLE milestone_t
    ADD COLUMN project_id VARCHAR(5),
    ADD CONSTRAINT milestone_t_fk2 FOREIGN KEY (project_id) REFERENCES project_t(project_id);

# each bug belongs to one game
ALTER TABLE bug_t
    ADD COLUMN game_name VARCHAR(50),
    ADD CONSTRAINT bug_t_fk2 FOREIGN KEY (game_name) REFERENCES game_t(game_name);

# assets link to projects by serial number
ALTER TABLE project_asset_t
    MODIFY asset_id VARCHAR(20) NOT NULL,
    ADD CONSTRAINT project_asset_t_fk2 FOREIGN KEY (asset_id) REFERENCES asset_t(serial_number);

# games and assets are many-to-many
CREATE TABLE game_asset_t (
    game_name VARCHAR(50) NOT NULL,
    serial_number VARCHAR(20) NOT NULL,
    CONSTRAINT game_asset_t_pk PRIMARY KEY(game_name, serial_number),
    CONSTRAINT game_asset_t_fk1 FOREIGN KEY (game_name) REFERENCES game_t(game_name),
    CONSTRAINT game_asset_t_fk2 FOREIGN KEY (serial_number) REFERENCES asset_t(serial_number)
);

#Triggers 
DELIMITER //
# update bug status when tester assigned
CREATE TRIGGER update_bug_status
BEFORE UPDATE ON bug_t
FOR EACH ROW
BEGIN
    IF NEW.employee_id IS NOT NULL AND OLD.employee_id IS NULL THEN
        SET NEW.status = 'In Progress';
    END IF;
END //

DELIMITER ;

DELIMITER //
# set project to complete when all tasks are complete
CREATE TRIGGER check_project_completion
AFTER UPDATE ON task_t
FOR EACH ROW
BEGIN
    DECLARE remaining_tasks INT;
    
    # only check when this update completed a task
    IF NEW.status = 'Completed' AND OLD.status != 'Completed'
       AND NEW.project_id IS NOT NULL THEN
    
        SELECT COUNT(*) INTO remaining_tasks
        FROM task_t
        WHERE project_id = NEW.project_id
        AND status != 'Completed';
        
        IF remaining_tasks = 0 THEN
            # keep end_date after start_date so end_date_chk still passes
            UPDATE project_t
            SET status = 'Completed',
                end_date = IF(CURDATE() > start_date, CURDATE(), end_date)
            WHERE project_id = NEW.project_id;
        END IF;
    END IF;
END //

DELIMITER ;

#Stored Procedures
DELIMITER //

CREATE PROCEDURE transfer_task_ownership(
    IN p_task_id INT,
    IN p_new_user_id VARCHAR(8),
    IN p_old_user_id VARCHAR(8)
)
BEGIN
    DECLARE v_user_exists INT DEFAULT 0;
    DECLARE v_task_exists INT DEFAULT 0;
    DECLARE v_current_owner VARCHAR(10);
    
    # check if the new user exists
    SELECT COUNT(*) INTO v_user_exists
    FROM employee_t
    WHERE employee_id = p_new_user_id;
    
    IF v_user_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NEW USER DOES NOT EXIST';
    END IF;
    
    # check if the task exists
    SELECT COUNT(*) INTO v_task_exists
    FROM task_t
    WHERE task_id = p_task_id;
    
    IF v_task_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'TASK DOES NOT EXIST';
    END IF;
    
    # check that the task belongs to the old user
    SELECT employee_id INTO v_current_owner
    FROM task_t
    WHERE task_id = p_task_id;
    
    IF v_current_owner IS NULL OR v_current_owner != p_old_user_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'TASK IS NOT OWNED BY THE OLD USER';
    END IF;
    
    # update the task ownership
    UPDATE task_t
    SET employee_id = p_new_user_id
    WHERE task_id = p_task_id;
END //


CREATE PROCEDURE update_task_status_from_logs(
    IN p_task_id INT
)
BEGIN
    DECLARE v_task_exists INT DEFAULT 0;
    DECLARE v_total_logged_hours INT DEFAULT 0;
    DECLARE v_task_type VARCHAR(20);
    DECLARE v_estimated_hours INT;
    DECLARE v_current_status VARCHAR(20);
    
    # check if task exists
    SELECT COUNT(*) INTO v_task_exists 
    FROM task_t 
    WHERE task_id = p_task_id;
    
    IF v_task_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'TASK DOES NOT EXIST';
    END IF;
    
    # get current task status and type
    SELECT status, type INTO v_current_status, v_task_type
    FROM task_t
    WHERE task_id = p_task_id;
    
    # skip if already completed
    IF v_current_status = 'Completed' THEN
        SELECT 'Task already completed' AS Message;
    ELSE
        # get total logged hours for this task
        SELECT IFNULL(SUM(hours_worked), 0) INTO v_total_logged_hours
        FROM time_log_t
        WHERE task_id = p_task_id;
        
        # determine estimated hours based on task type
        SET v_estimated_hours = 
            CASE 
                WHEN v_task_type = 'Developer' THEN 8
                WHEN v_task_type = 'Tester' THEN 4
                WHEN v_task_type = 'Manager' THEN 2
                ELSE 4
            END;
        
        # update status based on logged hours
        IF v_total_logged_hours = 0 THEN
            UPDATE task_t SET status = 'Pending' WHERE task_id = p_task_id;
        ELSEIF v_total_logged_hours >= v_estimated_hours THEN
            UPDATE task_t SET status = 'Completed' WHERE task_id = p_task_id;
        ELSE
            UPDATE task_t SET status = 'In Progress' WHERE task_id = p_task_id;
        END IF;
    END IF;
END //

DELIMITER ;

DESCRIBE employee_t;
DESCRIBE developer_t;
DESCRIBE tester_t;
DESCRIBE manager_t;
DESCRIBE task_t;
DESCRIBE developer_task_t;
DESCRIBE tester_task_t;
DESCRIBE manager_task_t;
DESCRIBE team_t;
DESCRIBE project_t;
DESCRIBE project_asset_t;
DESCRIBE budget_t;
DESCRIBE meeting_t;
DESCRIBE milestone_t;
DESCRIBE time_log_t;
DESCRIBE game_t;
DESCRIBE bug_t;
DESCRIBE bug_reporter_t;
DESCRIBE bug_tester_t;
DESCRIBE asset_t;
DESCRIBE hardware_asset_t;
DESCRIBE testing_device_t;
DESCRIBE server_asset_t;
DESCRIBE maintenance_t;
DESCRIBE maintenance_provider_t;
DESCRIBE marketing_campaign_t;
DESCRIBE player_feedback_t;
DESCRIBE game_asset_t;