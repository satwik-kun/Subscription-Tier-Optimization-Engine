-- =============================
-- DATABASE: subsys_db
-- Complete SQL Implementation with Constraints, Data, Triggers, Functions, Procedures, and Queries
-- =============================

-- Step 1: Create database
CREATE DATABASE IF NOT EXISTS subsys_db;
USE subsys_db;

-- Step 2: Drop existing tables to avoid conflicts
DROP TABLE IF EXISTS Recommendation;
DROP TABLE IF EXISTS System_Log;
DROP TABLE IF EXISTS User_Activity;
DROP TABLE IF EXISTS Tier_Features;
DROP TABLE IF EXISTS User_Friends;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Tier;
DROP TABLE IF EXISTS Feature;
DROP TABLE IF EXISTS Market_Segment;

-- Step 3: Create Tables
CREATE TABLE User (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(255) UNIQUE NOT NULL,
    join_date DATE,
    age INT,
    contact VARCHAR(50),
    preferences TEXT,
    current_tier_id INT,
    current_segment_id INT
);

CREATE TABLE User_Friends (
    user_id1 INT,
    user_id2 INT,
    status VARCHAR(50),
    PRIMARY KEY (user_id1, user_id2),
    FOREIGN KEY (user_id1) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id2) REFERENCES User(user_id) ON DELETE CASCADE
);

CREATE TABLE Tier (
    tier_id INT PRIMARY KEY AUTO_INCREMENT,
    tier_name VARCHAR(100),
    price DECIMAL(10,2),
    description TEXT
);

CREATE TABLE Feature (
    feature_id INT PRIMARY KEY AUTO_INCREMENT,
    feature_name VARCHAR(100),
    description TEXT
);

CREATE TABLE Tier_Features (
    tier_id INT,
    feature_id INT,
    restriction TEXT,
    PRIMARY KEY (tier_id, feature_id),
    FOREIGN KEY (tier_id) REFERENCES Tier(tier_id) ON DELETE CASCADE,
    FOREIGN KEY (feature_id) REFERENCES Feature(feature_id) ON DELETE CASCADE
);

CREATE TABLE User_Activity (
    activity_id INT PRIMARY KEY AUTO_INCREMENT,
    feature_id INT,
    user_id INT,
    timestamp DATETIME,
    duration INT,
    action_type VARCHAR(100),
    FOREIGN KEY (feature_id) REFERENCES Feature(feature_id) ON DELETE SET NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
);

CREATE TABLE System_Log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    activities_id INT,
    timestamp DATETIME,
    time_spent INT,
    action_details TEXT,
    FOREIGN KEY (activities_id) REFERENCES User_Activity(activity_id) ON DELETE CASCADE
);

CREATE TABLE Market_Segment (
    segment_id INT PRIMARY KEY AUTO_INCREMENT,
    segment_name VARCHAR(100),
    description TEXT,
    created_on DATE
);

CREATE TABLE Recommendation (
    feature_id INT,
    tier_id INT,
    user_id INT,
    recommendation_id INT PRIMARY KEY AUTO_INCREMENT,
    recommendation_test TEXT,
    created_on DATE,
    target_segment_id INT,
    FOREIGN KEY (feature_id) REFERENCES Feature(feature_id) ON DELETE SET NULL,
    FOREIGN KEY (tier_id) REFERENCES Tier(tier_id) ON DELETE SET NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (target_segment_id) REFERENCES Market_Segment(segment_id) ON DELETE SET NULL
);

ALTER TABLE User
ADD CONSTRAINT fk_user_tier FOREIGN KEY (current_tier_id) REFERENCES Tier(tier_id) ON DELETE SET NULL,
ADD CONSTRAINT fk_user_segment FOREIGN KEY (current_segment_id) REFERENCES Market_Segment(segment_id) ON DELETE SET NULL;

-- Step 4: Add Constraints
ALTER TABLE User
ADD COLUMN status ENUM('Active','Inactive','Banned') DEFAULT 'Active',
ADD CONSTRAINT chk_age CHECK (age >= 13);

-- Step 5: Insert Data (10 rows each table)
-- =============================

INSERT INTO Tier (tier_name, price, description) VALUES
('Free', 0.00, 'Basic plan with limited features'),
('Silver', 9.99, 'Intermediate plan for regular users'),
('Gold', 19.99, 'Premium plan with advanced features'),
('Platinum', 29.99, 'Full access to all features'),
('Business', 49.99, 'Business plan for teams'),
('Enterprise', 99.99, 'Corporate-level plan'),
('Student', 4.99, 'Discounted plan for students'),
('Family', 14.99, 'Shared access for up to 5 members'),
('Trial', 0.00, 'Limited time free trial'),
('Custom', 79.99, 'Tailor-made feature plan');

INSERT INTO Feature (feature_name, description) VALUES
('Analytics Dashboard', 'Provides user insights'),
('Priority Support', '24/7 premium support'),
('Data Export', 'Export reports in CSV'),
('Ad-Free Experience', 'Removes advertisements'),
('API Access', 'Developer API for integration'),
('Custom Themes', 'UI personalization'),
('Cloud Backup', 'Automatic cloud sync'),
('Team Collaboration', 'Invite team members'),
('Advanced Security', 'Two-factor authentication'),
('Beta Features', 'Access to new experimental features');

INSERT INTO Market_Segment (segment_name, description, created_on) VALUES
('Tech Enthusiasts', 'Users interested in latest tech', '2024-01-01'),
('Students', 'College and school students', '2024-02-10'),
('Businesses', 'Corporate clients', '2024-03-15'),
('Developers', 'Software engineers', '2024-04-05'),
('Families', 'Household shared users', '2024-05-20'),
('Startups', 'Small startup founders', '2024-06-01'),
('Researchers', 'Academic or scientific users', '2024-07-07'),
('Gamers', 'People who play games', '2024-08-08'),
('Marketers', 'People in marketing', '2024-09-09'),
('Educators', 'Teachers or trainers', '2024-10-10');

INSERT INTO User (first_name, last_name, email, join_date, age, contact, preferences, current_tier_id, current_segment_id) VALUES
('Alice', 'Johnson', 'alice@example.com', '2024-01-15', 25, '9991110001', 'Analytics, No Ads', 3, 1),
('Bob', 'Smith', 'bob@example.com', '2024-02-20', 30, '9991110002', 'API Access', 2, 4),
('Carol', 'Brown', 'carol@example.com', '2024-03-22', 28, '9991110003', 'Data Export', 4, 3),
('David', 'White', 'david@example.com', '2024-04-25', 22, '9991110004', 'Custom Themes', 1, 2),
('Eve', 'Davis', 'eve@example.com', '2024-05-30', 32, '9991110005', 'Cloud Backup', 5, 3),
('Frank', 'Miller', 'frank@example.com', '2024-06-10', 27, '9991110006', 'Team Collaboration', 4, 6),
('Grace', 'Wilson', 'grace@example.com', '2024-07-17', 35, '9991110007', 'Advanced Security', 6, 3),
('Henry', 'Taylor', 'henry@example.com', '2024-08-23', 21, '9991110008', 'Beta Features', 7, 2),
('Ivy', 'Anderson', 'ivy@example.com', '2024-09-05', 24, '9991110009', 'No Ads', 8, 5),
('Jake', 'Thomas', 'jake@example.com', '2024-10-11', 40, '9991110010', 'Priority Support', 9, 9);

INSERT INTO User_Friends VALUES
(1,2,'Accepted'),
(1,3,'Pending'),
(2,4,'Accepted'),
(3,4,'Accepted'),
(4,5,'Pending'),
(5,6,'Accepted'),
(6,7,'Accepted'),
(7,8,'Blocked'),
(8,9,'Accepted'),
(9,10,'Accepted');

INSERT INTO Tier_Features VALUES
(1,1,'Limited'),
(2,3,'Unlimited'),
(3,4,'Unlimited'),
(4,5,'Unlimited'),
(5,6,'Unlimited'),
(6,7,'Unlimited'),
(7,2,'Limited'),
(8,8,'Unlimited'),
(9,9,'Limited'),
(10,10,'Unlimited');

INSERT INTO User_Activity (feature_id, user_id, timestamp, duration, action_type) VALUES
(1,1,NOW(),30,'View'),
(2,2,NOW(),15,'Click'),
(3,3,NOW(),60,'Export'),
(4,4,NOW(),25,'View'),
(5,5,NOW(),40,'API Call'),
(6,6,NOW(),50,'Customize'),
(7,7,NOW(),35,'Sync'),
(8,8,NOW(),20,'Collaborate'),
(9,9,NOW(),45,'Login'),
(10,10,NOW(),30,'Try Beta');

INSERT INTO System_Log (activities_id, timestamp, time_spent, action_details) VALUES
(1,NOW(),30,'Viewed dashboard'),
(2,NOW(),15,'Clicked support link'),
(3,NOW(),60,'Exported report'),
(4,NOW(),25,'Viewed ad-free page'),
(5,NOW(),40,'Made API call'),
(6,NOW(),50,'Changed theme'),
(7,NOW(),35,'Synced backup'),
(8,NOW(),20,'Collaborated with team'),
(9,NOW(),45,'2FA login'),
(10,NOW(),30,'Tried beta features');

INSERT INTO Recommendation (feature_id, tier_id, user_id, recommendation_test, created_on, target_segment_id) VALUES
(1,1,1,'Recommend upgrade to Silver', '2024-01-20', 2),
(2,2,2,'Try new dashboard features', '2024-02-25', 1),
(3,3,3,'Use API for automation', '2024-03-30', 4),
(4,4,4,'Upgrade to Gold plan', '2024-04-10', 3),
(5,5,5,'Switch to Business plan', '2024-05-15', 3),
(6,6,6,'Enable advanced security', '2024-06-25', 3),
(7,7,7,'Access beta features', '2024-07-20', 2),
(8,8,8,'Try team collaboration', '2024-08-22', 5),
(9,9,9,'Try family plan', '2024-09-30', 5),
(10,10,10,'Move to Enterprise', '2024-10-05', 9);

-- =============================
-- Queries
-- =============================

-- Query #1
SELECT 
    t.tier_name AS tier,
    ROUND(AVG(a.duration), 2) AS avg_engagement,
    t.price AS tier_price,
    COUNT(DISTINCT u.user_id) AS user_count
FROM Tier t
JOIN User u ON t.tier_id = u.current_tier_id
JOIN User_Activity a ON a.user_id = u.user_id
GROUP BY t.tier_id
ORDER BY avg_engagement DESC;

-- Query #2
SELECT 
    f.feature_name, 
    SUM(a.duration) AS total_time,
    COUNT(a.activity_id) AS total_sessions
FROM Feature f
JOIN User_Activity a ON f.feature_id = a.feature_id
GROUP BY f.feature_id
ORDER BY total_time DESC
LIMIT 5;

-- Query #3
SELECT 
    m.segment_name,
    ROUND(AVG(a.duration), 2) AS avg_engagement,
    RANK() OVER (ORDER BY AVG(a.duration) DESC) AS rank_seg
FROM Market_Segment m
JOIN User u ON m.segment_id = u.current_segment_id
JOIN User_Activity a ON a.user_id = u.user_id
GROUP BY m.segment_id;

-- Query #4
SELECT 
    SELECT 
            activity_level,
            COUNT(DISTINCT user_id) AS total_users
        FROM (
            SELECT 
                user_id,
                CASE 
                    WHEN SUM(duration) > 100 THEN 'Highly Active'
                    WHEN SUM(duration) BETWEEN 50 AND 100 THEN 'Moderately Active'
                    ELSE 'Low Activity'
                END AS activity_level
            FROM User_Activity
            GROUP BY user_id
        ) AS sub
        GROUP BY activity_level
        ORDER BY total_users DESC;

-- Query #5
SELECT 
    f.feature_name,
    COUNT(DISTINCT a.user_id) AS unique_users,
    ROUND((COUNT(DISTINCT a.user_id) / (SELECT COUNT(*) FROM User)) * 100, 2) AS retention_rate
FROM Feature f
JOIN User_Activity a ON f.feature_id = a.feature_id
GROUP BY f.feature_id
ORDER BY retention_rate DESC;

-- =============================
-- Step 7: Trigger, Function, Procedure
-- =============================

DELIMITER //
CREATE TRIGGER trg_user_insert
AFTER INSERT ON User
FOR EACH ROW
BEGIN
    INSERT INTO System_Log (activities_id, timestamp, time_spent, action_details)
    VALUES (1, NOW(), 0, CONCAT('New user created: ', NEW.email));
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION total_time_spent(uid INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT SUM(duration) INTO total FROM User_Activity WHERE user_id = uid;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE recommend_upgrade()
BEGIN
    SELECT 
        u.first_name, 
        u.last_name, 
        AVG(a.duration) AS avg_dur
    FROM User u 
    JOIN User_Activity a ON u.user_id = a.user_id
    GROUP BY u.user_id
    HAVING avg_dur > 50;
END //
DELIMITER ;

-- =============================
-- DEMO Queries
-- =============================

-- 1. Feature Insights
INSERT INTO user_activity VALUES (11,9,2,NOW(),55,'Login');

-- 2. User Insights
INSERT INTO user VALUES (99,'chola','kun','satwik123@gmail.com','2024-01-01',56,8907654278,'custom themes',2,1,'Active');
INSERT INTO user_activity VALUES (11,1,99,NOW(),100,'login');

-- 3. High-Engagement Users
DELIMITER //
CREATE PROCEDURE recommend_upgrade()
BEGIN
    SELECT 
        u.first_name, 
        u.last_name, 
        AVG(a.duration) AS avg_dur
    FROM User u 
    JOIN User_Activity a ON u.user_id = a.user_id
    GROUP BY u.user_id
    HAVING avg_dur > 50;
END //
DELIMITER ;

-- 4. Tier-Engagement 
INSERT INTO user VALUES (99,'chola','kun','satwik123@gmail.com','2024-01-01',56,8907654278,'custom themes',6,1,'Active');
INSERT INTO user_activity VALUES (11,1,99,NOW(),100,'login');

CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'Admin@123';
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY 'Analyst@123';
GRANT ALL PRIVILEGES ON subsys_db.* TO 'admin_user'@'localhost';
GRANT SELECT ON subsys_db.* TO 'data_analyst'@'localhost';

CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'Admin@123';
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY 'Analyst@123';
GRANT ALL PRIVILEGES ON subsys_db.* TO 'admin_user'@'localhost';
GRANT SELECT ON subsys_db.* TO 'data_analyst'@'localhost';
add this on notepad