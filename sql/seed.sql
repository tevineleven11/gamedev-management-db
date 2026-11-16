-- seed.sql: sample data for the Vortex Game Studio database
-- Run after schema.sql. 

USE vortex_studio;

INSERT INTO project_t (project_id, name, start_date, end_date, budget, status) VALUES
('PRJ01', 'Skyward Racer',  '2026-01-15', '2026-09-30', 450000.00, 'Completed'),
('PRJ02', 'Dungeon Ledger', '2026-03-01', '2027-02-28', 800000.00, 'Active'),
('PRJ03', 'Pocket Farm',    '2026-06-01', '2026-12-15', 250000.00, 'Active'),
('PRJ04', 'Orbit Tactics',  '2027-01-11', '2027-10-29', 600000.00, 'Planning');

INSERT INTO budget_t (budget_id, allocated_amount, spent_amount, remaining_amount, project_id) VALUES
('BUD01', 450000.00, 438500.00,  11500.00, 'PRJ01'),
('BUD02', 800000.00, 512300.00, 287700.00, 'PRJ02'),
('BUD03', 250000.00,  96400.00, 153600.00, 'PRJ03'),
('BUD04', 600000.00,      0.00, 600000.00, 'PRJ04');

INSERT INTO team_t (team_name, team_size, project_id) VALUES
('Falcon',  6, 'PRJ01'),
('Griffin', 8, 'PRJ02'),
('Sprout',  5, 'PRJ03'),
('Nebula',  5, 'PRJ04');

INSERT INTO employee_t (employee_id, name, surname, id_number, email, experience_level, role, team_name) VALUES
('EMP00001', 'Ayanda', 'Mokoena',  '0000000000001', 'ayanda.mokoena@vortexstudio.example', 'Senior', 'Manager',   'Falcon'),
('EMP00002', 'Priya',  'Govender', '0000000000002', 'priya.govender@vortexstudio.example', 'Senior', 'Developer', 'Falcon'),
('EMP00003', 'Liam',   'Botha',    '0000000000003', 'liam.botha@vortexstudio.example',     'Mid',    'Developer', 'Falcon'),
('EMP00004', 'Zanele', 'Dube',     '0000000000004', 'zanele.dube@vortexstudio.example',    'Mid',    'Tester',    'Falcon'),
('EMP00005', 'Rashid', 'Khan',     '0000000000005', 'rashid.khan@vortexstudio.example',    'Senior', 'Manager',   'Griffin'),
('EMP00006', 'Thabo',  'Nkosi',    '0000000000006', 'thabo.nkosi@vortexstudio.example',    'Senior', 'Developer', 'Griffin'),
('EMP00007', 'Megan',  'Pillay',   '0000000000007', 'megan.pillay@vortexstudio.example',   'Junior', 'Developer', 'Griffin'),
('EMP00008', 'Sipho',  'Zulu',     '0000000000008', 'sipho.zulu@vortexstudio.example',     'Senior', 'Tester',    'Griffin'),
('EMP00009', 'Chloe',  'van Wyk',  '0000000000009', 'chloe.vanwyk@vortexstudio.example',   'Mid',    'Manager',   'Sprout'),
('EMP00010', 'Kagiso', 'Molefe',   '0000000000010', 'kagiso.molefe@vortexstudio.example',  'Mid',    'Developer', 'Sprout'),
('EMP00011', 'Aisha',  'Patel',    '0000000000011', 'aisha.patel@vortexstudio.example',    'Junior', 'Tester',    'Sprout'),
('EMP00012', 'Daniel', 'Fourie',   '0000000000012', 'daniel.fourie@vortexstudio.example',  'Junior', 'Developer', 'Nebula'),
('EMP00013', 'Nomsa',  'Khumalo',  '0000000000013', 'nomsa.khumalo@vortexstudio.example',  'Mid',    'Tester',    NULL);

INSERT INTO developer_t (employee_id, programming_language, tool) VALUES
('EMP00002', 'Python',     'PyCharm'),
('EMP00003', 'C++',        'VS Code'),
('EMP00006', 'C#',         'VS Code'),
('EMP00007', 'JavaScript', 'VS Code'),
('EMP00010', 'Java',       'IntelliJ'),
('EMP00012', 'C++',        'VS Code');

INSERT INTO tester_t (employee_id, testing_type, tool) VALUES
('EMP00004', 'Automated', 'Selenium'),
('EMP00008', 'Automated', 'JMeter'),
('EMP00011', 'Manual',    'JIRA'),
('EMP00013', 'Manual',    'TestRail');

INSERT INTO manager_t (employee_id, management_style, employee_satisfaction) VALUES
('EMP00001', 'Democratic',       82),
('EMP00005', 'Transformational', 91),
('EMP00009', 'Laissez-faire',    68);

-- Assign managers to teams. Nebula has no manager yet (project still in planning).
UPDATE team_t SET manager_id = 'EMP00001' WHERE team_name = 'Falcon';
UPDATE team_t SET manager_id = 'EMP00005' WHERE team_name = 'Griffin';
UPDATE team_t SET manager_id = 'EMP00009' WHERE team_name = 'Sprout';

INSERT INTO task_t (task_id, description, due_date, status, type, employee_id, project_id) VALUES
(1,  'Implement vehicle physics engine', '2026-03-31', 'Completed',   'Developer', 'EMP00002', 'PRJ01'),
(2,  'Build track editor',               '2026-05-15', 'Completed',   'Developer', 'EMP00003', 'PRJ01'),
(3,  'Regression test race modes',       '2026-08-20', 'Completed',   'Tester',    'EMP00004', 'PRJ01'),
(4,  'Launch readiness review',          '2026-09-15', 'Completed',   'Manager',   'EMP00001', 'PRJ01'),
(5,  'Design inventory system',          '2026-06-30', 'Completed',   'Developer', 'EMP00006', 'PRJ02'),
(6,  'Implement turn-based combat',      '2026-11-28', 'In Progress', 'Developer', 'EMP00006', 'PRJ02'),
(7,  'Build save and load feature',      '2026-12-12', 'In Progress', 'Developer', 'EMP00007', 'PRJ02'),
(8,  'Load test multiplayer servers',    '2026-12-05', 'Pending',     'Tester',    'EMP00008', 'PRJ02'),
(9,  'Automate combat test suite',       '2026-11-06', 'Blocked',     'Tester',    'EMP00008', 'PRJ02'),
(10, 'Sprint planning session',          '2026-11-10', 'Completed',   'Manager',   'EMP00005', 'PRJ02'),
(11, 'Create crop growth mechanics',     '2026-09-30', 'Completed',   'Developer', 'EMP00010', 'PRJ03'),
(12, 'Add in-app store',                 '2026-11-25', 'In Progress', 'Developer', 'EMP00010', 'PRJ03'),
(13, 'Manual test on low-end devices',   '2026-12-01', 'Pending',     'Tester',    'EMP00011', 'PRJ03'),
(14, 'Scope review with publisher',      '2026-10-20', 'Completed',   'Manager',   'EMP00009', 'PRJ03');

INSERT INTO developer_task_t (task_id, code_volume, documented) VALUES
(1,  12400, TRUE),
(2,   8600, TRUE),
(5,   5200, TRUE),
(6,   3100, FALSE),
(7,   1450, FALSE),
(11,  4300, TRUE),
(12,   900, FALSE);

INSERT INTO tester_task_t (task_id, execution_time, coverage) VALUES
(3,  46.50, 92),
(8,   0.00,  0),
(9,  12.25, 35),
(13,  0.00,  0);

INSERT INTO manager_task_t (task_id, information_discussed, session_outcome) VALUES
(4,  'Release checklist and store submission', 'Resolved'),
(10, 'Combat feature scope for next sprint',   'Resolved'),
(14, 'Publisher request for extra crop types', 'Escalated');

INSERT INTO asset_t (serial_number, manufacturer, model_number, purchase_date, item_condition, type) VALUES
('SN-HW-00000000000001', 'Dell',    'Precision 5860', '2024-02-12', 'Good', 'Hardware'),
('SN-HW-00000000000002', 'Lenovo',  'ThinkPad P1',    '2025-01-20', 'Good', 'Hardware'),
('SN-HW-00000000000003', 'LG',      'UltraFine 27',   '2023-07-05', 'Fair', 'Hardware'),
('SN-HW-00000000000004', 'HP',      'LaserJet M404',  '2022-03-18', 'Poor', 'Hardware'),
('SN-TD-00000000000001', 'Samsung', 'Galaxy S24',     '2025-02-01', 'Good', 'Testing'),
('SN-TD-00000000000002', 'Apple',   'iPad Air',       '2025-03-10', 'New',  'Testing'),
('SN-TD-00000000000003', 'Sony',    'PlayStation 5',  '2024-11-22', 'Good', 'Testing'),
('SN-SV-00000000000001', 'Dell',    'PowerEdge R750', '2024-06-01', 'Good', 'Server'),
('SN-SV-00000000000002', 'HPE',     'ProLiant DL380', '2025-04-15', 'New',  'Server');

INSERT INTO hardware_asset_t (serial_number, equipment_type, connectivity_type) VALUES
('SN-HW-00000000000001', 'Computer', 'Wired'),
('SN-HW-00000000000002', 'Laptop',   'Wireless'),
('SN-HW-00000000000003', 'Monitor',  'Wired'),
('SN-HW-00000000000004', 'Printer',  'Wireless');

INSERT INTO testing_device_t (serial_number, device_type, platform, firmware_version) VALUES
('SN-TD-00000000000001', 'Mobile',  'Android',     '14.0'),
('SN-TD-00000000000002', 'Tablet',  'iOS',         '17.4'),
('SN-TD-00000000000003', 'Console', 'PlayStation', '9.20');

INSERT INTO game_t (game_name, genre, platform, project_id) VALUES
('Skyward Racer',  'Sports',     'Console', 'PRJ01'),
('Dungeon Ledger', 'RPG',        'PC',      'PRJ02'),
('Pocket Farm',    'Simulation', 'Mobile',  'PRJ03'),
('Orbit Tactics',  'Strategy',   'PC',      'PRJ04');

INSERT INTO server_asset_t (serial_number, server_type, storage_capacity, ip_address, game_name) VALUES
('SN-SV-00000000000001', 'Application', '20TB', '10.0.1.10', 'Skyward Racer'),
('SN-SV-00000000000002', 'Database',    '40TB', '10.0.1.11', 'Dungeon Ledger');

INSERT INTO game_asset_t (game_name, serial_number) VALUES
('Skyward Racer',  'SN-HW-00000000000001'),
('Skyward Racer',  'SN-TD-00000000000003'),
('Skyward Racer',  'SN-SV-00000000000001'),
('Dungeon Ledger', 'SN-HW-00000000000002'),
('Dungeon Ledger', 'SN-HW-00000000000003'),
('Dungeon Ledger', 'SN-SV-00000000000002'),
('Pocket Farm',    'SN-TD-00000000000001'),
('Pocket Farm',    'SN-TD-00000000000002'),
('Orbit Tactics',  'SN-HW-00000000000001');

INSERT INTO project_asset_t (project_id, asset_id) VALUES
('PRJ01', 'SN-HW-00000000000001'),
('PRJ01', 'SN-TD-00000000000003'),
('PRJ01', 'SN-SV-00000000000001'),
('PRJ02', 'SN-HW-00000000000002'),
('PRJ02', 'SN-HW-00000000000003'),
('PRJ02', 'SN-SV-00000000000002'),
('PRJ03', 'SN-TD-00000000000001'),
('PRJ03', 'SN-TD-00000000000002');

INSERT INTO meeting_t (meeting_id, agenda, date, manager_name, employee_id, team_name) VALUES
('MTG01', 'Skyward Racer launch readiness', '2026-09-14', 'Ayanda Mokoena', 'EMP00001', 'Falcon'),
('MTG02', 'Dungeon Ledger sprint planning', '2026-11-09', 'Rashid Khan',    'EMP00005', 'Griffin'),
('MTG03', 'Pocket Farm scope review',       '2026-10-19', 'Chloe van Wyk',  'EMP00009', 'Sprout'),
('MTG04', 'Orbit Tactics kickoff',          '2026-12-02', 'Rashid Khan',    'EMP00005', 'Nebula');

INSERT INTO milestone_t (milestone_id, name, due_date, status, meeting_id, project_id) VALUES
('MS001', 'Skyward Racer gold master',      '2026-09-25', 'Completed',   'MTG01', 'PRJ01'),
('MS002', 'Dungeon Ledger combat alpha',    '2026-12-15', 'In Progress', 'MTG02', 'PRJ02'),
('MS003', 'Dungeon Ledger closed beta',     '2027-01-30', 'Scheduled',   'MTG02', 'PRJ02'),
('MS004', 'Pocket Farm soft launch',        '2026-12-10', 'In Progress', 'MTG03', 'PRJ03'),
('MS005', 'Orbit Tactics concept approval', '2027-01-20', 'Scheduled',   'MTG04', 'PRJ04');

INSERT INTO time_log_t (log_id, log_date, hours_worked, employee, task_id, employee_id) VALUES
('L0001', '2026-02-10', 8, 'Priya Govender', 1,  'EMP00002'),
('L0002', '2026-02-11', 7, 'Priya Govender', 1,  'EMP00002'),
('L0003', '2026-04-02', 8, 'Liam Botha',     2,  'EMP00003'),
('L0004', '2026-04-03', 6, 'Liam Botha',     2,  'EMP00003'),
('L0005', '2026-08-12', 6, 'Zanele Dube',    3,  'EMP00004'),
('L0006', '2026-09-14', 2, 'Ayanda Mokoena', 4,  'EMP00001'),
('L0007', '2026-06-15', 8, 'Thabo Nkosi',    5,  'EMP00006'),
('L0008', '2026-06-16', 5, 'Thabo Nkosi',    5,  'EMP00006'),
('L0009', '2026-11-09', 4, 'Thabo Nkosi',    6,  'EMP00006'),
('L0010', '2026-11-10', 2, 'Thabo Nkosi',    6,  'EMP00006'),
('L0011', '2026-11-11', 5, 'Megan Pillay',   7,  'EMP00007'),
('L0012', '2026-11-03', 3, 'Sipho Zulu',     9,  'EMP00008'),
('L0013', '2026-11-09', 2, 'Rashid Khan',    10, 'EMP00005'),
('L0014', '2026-09-21', 8, 'Kagiso Molefe',  11, 'EMP00010'),
('L0015', '2026-11-12', 5, 'Kagiso Molefe',  12, 'EMP00010'),
('L0016', '2026-11-13', 4, 'Kagiso Molefe',  12, 'EMP00010'),
('L0017', '2026-10-19', 2, 'Chloe van Wyk',  14, 'EMP00009');

-- employee_id here is the assigned tester; NULL means not yet assigned
INSERT INTO bug_t (bug_id, description, severity, status, employee_id, game_name) VALUES
(1, 'Car clips through barrier on track 3',         'High',     'Fixed',       'EMP00004', 'Skyward Racer'),
(2, 'Lap timer resets after pause',                 'Medium',   'Fixed',       'EMP00004', 'Skyward Racer'),
(3, 'Inventory duplicates items on quick save',     'Critical', 'In Progress', 'EMP00008', 'Dungeon Ledger'),
(4, 'Combat log overlaps health bar',               'Low',      'Reported',    NULL,       'Dungeon Ledger'),
(5, 'Crash when loading save from older version',   'High',     'In Progress', 'EMP00008', 'Dungeon Ledger'),
(6, 'Crops do not grow while app is in background', 'Medium',   'In Progress', 'EMP00011', 'Pocket Farm'),
(7, 'Store prices show wrong currency symbol',      'Low',      'Wont Fix',    'EMP00011', 'Pocket Farm'),
(8, 'Frame rate drops in large dungeon rooms',      'High',     'Reported',    NULL,       'Dungeon Ledger');

INSERT INTO bug_reporter_t (bug_id, developer_name, employee_id) VALUES
(1, 'Liam Botha',     'EMP00003'),
(2, 'Priya Govender', 'EMP00002'),
(3, 'Megan Pillay',   'EMP00007'),
(4, 'Thabo Nkosi',    'EMP00006'),
(5, 'Megan Pillay',   'EMP00007'),
(6, 'Kagiso Molefe',  'EMP00010'),
(7, 'Kagiso Molefe',  'EMP00010'),
(8, 'Thabo Nkosi',    'EMP00006');

INSERT INTO bug_tester_t (bug_id, tester_name, employee_id) VALUES
(1, 'Zanele Dube', 'EMP00004'),
(2, 'Zanele Dube', 'EMP00004'),
(3, 'Sipho Zulu',  'EMP00008'),
(3, 'Zanele Dube', 'EMP00004'),
(5, 'Sipho Zulu',  'EMP00008'),
(6, 'Aisha Patel', 'EMP00011'),
(7, 'Aisha Patel', 'EMP00011');

INSERT INTO maintenance_provider_t (provider_id, company_name, contact_person, email, phone_number) VALUES
('PRV001', 'KZN Tech Repairs',    'Sibusiso Mthembu', 'support@kzntechrepairs.example', '031-555-0101'),
('PRV002', 'ServerCare SA',       'Lerato Naidoo',    'help@servercare.example',        '011-555-0142'),
('PRV003', 'Coastal IT Services', 'Johan Smit',       'info@coastalit.example',         '031-555-0177');

INSERT INTO maintenance_t (maintenance_id, description, date, cost, provider, serial_number, provider_id) VALUES
(1, 'Replaced faulty power supply',        '2025-08-14', 1850.00, 'KZN Tech Repairs',    'SN-HW-00000000000001', 'PRV001'),
(2, 'Printer drum and roller replacement', '2026-02-03', 2400.00, 'KZN Tech Repairs',    'SN-HW-00000000000004', 'PRV001'),
(3, 'RAID controller firmware update',     '2026-05-20', 3200.00, 'ServerCare SA',       'SN-SV-00000000000001', 'PRV002'),
(4, 'Replaced failed drive in array',      '2026-08-11', 5600.00, 'ServerCare SA',       'SN-SV-00000000000001', 'PRV002'),
(5, 'Screen replacement',                  '2026-07-07', 2950.00, 'Coastal IT Services', 'SN-TD-00000000000001', 'PRV003'),
(6, 'Printer paper feed repair',           '2026-09-29', 1200.00, 'KZN Tech Repairs',    'SN-HW-00000000000004', 'PRV001'),
(7, 'Annual server health check',          '2026-10-15', 4100.00, 'ServerCare SA',       'SN-SV-00000000000002', 'PRV002');

INSERT INTO marketing_campaign_t (campaign_id, start_date, end_date, target_audience, platform, game_name) VALUES
(1, '2026-09-01', '2026-10-15', 'Hardcore Gamers', 'Influencers',  'Skyward Racer'),
(2, '2026-10-01', '2026-11-30', 'All Ages',        'TV',           'Skyward Racer'),
(3, '2026-11-01', '2026-12-31', 'Casual Players',  'Social Media', 'Pocket Farm'),
(4, '2026-11-10', '2027-01-10', 'Teens',           'Online Ads',   'Dungeon Ledger');

INSERT INTO player_feedback_t (feedback_id, date, rating, description, campaign_id) VALUES
(1, '2026-09-20', 4.50, 'Great sense of speed, tracks look fantastic', 1),
(2, '2026-09-28', 3.75, 'Fun but needs more cars',                     1),
(3, '2026-10-05', 4.25, 'Handling feels tight on a controller',        1),
(4, '2026-10-18', 4.00, 'Saw the TV ad, kids love it',                 2),
(5, '2026-11-02', 2.50, 'Too many menus before you can race',          2),
(6, '2026-11-08', 4.75, 'Relaxing and easy to pick up',                3),
(7, '2026-11-12', 3.50, 'Crops take too long to grow',                 3),
(8, '2026-11-14', 4.00, 'Cute art style',                              3),
(9, '2026-11-15', 4.00, 'Trailer looks good, keen to try the combat',  4);