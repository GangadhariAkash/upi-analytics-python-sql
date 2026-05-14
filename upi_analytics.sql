CREATE DATABASE upi_analytics;
USE upi_analytics;
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);
CREATE TABLE upi_apps (
    app_id INT PRIMARY KEY AUTO_INCREMENT,
    app_name VARCHAR(50)
);
INSERT INTO upi_apps (app_name) VALUES
('Google Pay'),
('PhonePe'),
('Paytm'),
('Amazon Pay');
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    app_id INT,
    amount DECIMAL(10,2),
    transaction_time DATETIME,
    transaction_type VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (app_id) REFERENCES upi_apps(app_id)
);
CREATE TABLE first_names (
    name VARCHAR(50)
);
INSERT INTO first_names VALUES
('Rahul'),('Amit'),('Karan'),('Arjun'),('Rohit'),
('Vikram'),('Suresh'),('Manoj'),('Anil'),('Deepak'),
('Priya'),('Sneha'),('Anjali'),('Pooja'),('Kavya'),
('Neha'),('Riya'),('Divya'),('Meera'),('Shreya'),
('Varun'),('Nikhil'),('Harish'),('Tarun'),('Aditya');
CREATE TABLE last_names (
    name VARCHAR(50)
);
INSERT INTO last_names VALUES
('Sharma'),('Verma'),('Reddy'),('Patel'),('Singh'),
('Kumar'),('Gupta'),('Mehta'),('Iyer'),('Rao'),
('Kapoor'),('Joshi'),('Malhotra'),('Nair'),('Chopra'),
('Desai'),('Yadav'),('Bansal'),('Agarwal'),('Mishra'),
('Choudhary'),('Tiwari'),('Saxena'),('Pandey'),('Thakur');
INSERT INTO users (full_name, city, signup_date)
SELECT 
    CONCAT(f.name, ' ', l.name),
    ELT(FLOOR(1 + (RAND()*6)),
        'Hyderabad','Mumbai','Delhi','Bangalore','Chennai','Pune'
    ),
    DATE_ADD('2023-01-01', INTERVAL FLOOR(RAND()*365) DAY)
FROM first_names f
CROSS JOIN last_names l
LIMIT 500;
SELECT COUNT(*) FROM users;
INSERT INTO transactions 
(user_id, app_id, amount, transaction_time, transaction_type)
SELECT 
    FLOOR(1 + (RAND()*500)),
    FLOOR(1 + (RAND()*4)),
    ROUND(50 + (RAND()*49950),2),
    DATE_ADD('2026-01-01', INTERVAL FLOOR(RAND()*90) DAY)
        + INTERVAL FLOOR(RAND()*24) HOUR
        + INTERVAL FLOOR(RAND()*60) MINUTE,
    ELT(FLOOR(1 + (RAND()*3)),
        'P2P','P2M','Recharge'
    )
FROM (
    SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
) a,
(
    SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
) b,
(
    SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
) c,
(
    SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
) d
LIMIT 5000;
SELECT COUNT(*) FROM transactions;
SELECT SUM(amount) AS total_revenue
FROM transactions;
SELECT 
    a.app_name,
    SUM(t.amount) AS total_revenue
FROM transactions t
JOIN upi_apps a ON t.app_id = a.app_id
GROUP BY a.app_name
ORDER BY total_revenue DESC;
SELECT 
    u.city,
    SUM(t.amount) AS total_revenue
FROM transactions t
JOIN users u ON t.user_id = u.user_id
GROUP BY u.city
ORDER BY total_revenue DESC;
SELECT 
    u.full_name,
    SUM(t.amount) AS total_spent
FROM transactions t
JOIN users u ON t.user_id = u.user_id
GROUP BY u.full_name
ORDER BY total_spent DESC
LIMIT 10;
SELECT 
    u.full_name,
    SUM(t.amount) AS total_spent,
    CASE 
        WHEN SUM(t.amount) > 100000 THEN 'Gold'
        WHEN SUM(t.amount) BETWEEN 50000 AND 100000 THEN 'Silver'
        ELSE 'Bronze'
    END AS segment
FROM transactions t
JOIN users u ON t.user_id = u.user_id
GROUP BY u.full_name;
SELECT *
FROM transactions
WHERE amount > (
    SELECT AVG(amount) * 3 FROM transactions
);
SELECT 
    user_id,
    DATE_FORMAT(transaction_time,'%Y-%m-%d %H:%i') AS minute_block,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY user_id, minute_block
HAVING transaction_count > 3;
SELECT 
    user_id,
    transaction_time,
    amount,
    LAG(amount) OVER (PARTITION BY user_id ORDER BY transaction_time) AS previous_amount,
    amount - LAG(amount) OVER (PARTITION BY user_id ORDER BY transaction_time) AS difference
FROM transactions;
DROP TABLE user_risk_summary;
CREATE TABLE user_risk_summary (
    user_id INT,
    full_name VARCHAR(100),
    total_transactions INT,
    total_spent DECIMAL(15,2),
    avg_transaction DECIMAL(15,2),
    highest_transaction DECIMAL(15,2),
    fraud_score INT DEFAULT 0,
    risk_level VARCHAR(20)
);
DESC user_risk_summary;
ALTER TABLE user_risk_summary
MODIFY avg_transaction DECIMAL(10,2);
TRUNCATE TABLE user_risk_summary;
DESC user_risk_summary;
ALTER TABLE user_risk_summary
MODIFY total_spent DECIMAL(15,2),
MODIFY avg_transaction DECIMAL(15,2),
MODIFY highest_transaction DECIMAL(15,2);
TRUNCATE TABLE user_risk_summary;
CREATE INDEX idx_transactions_user
ON transactions(user_id);
CREATE INDEX idx_transactions_time
ON transactions(transaction_time);
CREATE INDEX idx_risk_level
ON user_risk_summary(risk_level);
SELECT 
    DATE_FORMAT(transaction_time,'%Y-%m') AS month,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_revenue,
    AVG(amount) AS avg_transaction
FROM transactions
GROUP BY month
ORDER BY month;
SELECT *
FROM transactions
WHERE amount > (
    SELECT AVG(amount) + (2 * STDDEV(amount))
    FROM transactions
);
SELECT 
    user_id,
    SUM(amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(amount) DESC) AS spending_rank
FROM transactions
GROUP BY user_id;
CREATE VIEW v_user_financial_summary AS
SELECT 
    u.user_id,
    u.full_name,
    COUNT(t.transaction_id) AS total_transactions,
    SUM(t.amount) AS total_spent,
    AVG(t.amount) AS avg_transaction,
    MAX(t.amount) AS highest_transaction
FROM users u
JOIN transactions t ON u.user_id = t.user_id
GROUP BY u.user_id, u.full_name;
SELECT * FROM v_user_financial_summary;
DELIMITER //

CREATE PROCEDURE refresh_user_risk_summary()
BEGIN

    -- Clear old data
    TRUNCATE TABLE user_risk_summary;

    -- Insert fresh aggregation
    INSERT INTO user_risk_summary
    (user_id, full_name, total_transactions, total_spent, avg_transaction, highest_transaction)

    SELECT 
        u.user_id,
        u.full_name,
        COUNT(t.transaction_id),
        SUM(t.amount),
        AVG(t.amount),
        MAX(t.amount)
    FROM users u
    JOIN transactions t ON u.user_id = t.user_id
    GROUP BY u.user_id, u.full_name;

    -- Apply fraud score logic
    UPDATE user_risk_summary
    SET fraud_score =
        (CASE WHEN highest_transaction > 40000 THEN 40 ELSE 0 END) +
        (CASE WHEN avg_transaction > 20000 THEN 30 ELSE 0 END) +
        (CASE WHEN total_transactions > 25 THEN 20 ELSE 0 END) +
        (CASE WHEN total_spent > 200000 THEN 10 ELSE 0 END);

    -- Apply risk classification
    UPDATE user_risk_summary
    SET risk_level =
        CASE 
            WHEN fraud_score >= 70 THEN 'High Risk'
            WHEN fraud_score BETWEEN 40 AND 69 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END;

END //
DELIMITER ;
CREATE EVENT daily_refresh
ON SCHEDULE EVERY 1 DAY
DO
CALL refresh_user_risk_summary();
SELECT 
    risk_level,
    COUNT(*) AS users_count,
    SUM(total_spent) AS revenue_from_segment
FROM user_risk_summary
GROUP BY risk_level;
SET SQL_SAFE_UPDATES = 0;

CALL refresh_user_risk_summary();

SELECT * FROM user_risk_summary;
SET SQL_SAFE_UPDATES = 0;
CALL refresh_user_risk_summary();
SELECT 
    risk_level,
    COUNT(*) AS users_count,
    SUM(total_spent) AS revenue_from_segment
FROM user_risk_summary
GROUP BY risk_level;
SET GLOBAL event_scheduler = ON;