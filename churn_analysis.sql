## Using PostgreSQL

#Create table customers:
CREATE TABLE IF NOT EXISTS customers (
customer_id SERIAL PRIMARY KEY,
name VARCHAR(50),
signup_date DATE,
country VARCHAR(50)
);

#Create table subscriptions:
CREATE TABLE IF NOT EXISTS subscriptions (
sub_id SERIAL PRIMARY KEY,
customer_id INT REFERENCES customers(customer_id),
plan_type VARCHAR(50) NOT NULL,
start_date DATE NOT NULL,
end_date DATE,
is_cancelled BOOLEAN
);

#Create table activity_logs:
CREATE TABLE IF NOT EXISTS activity_logs (
log_id SERIAL PRIMARY KEY,
customer_id INT REFERENCES customers(customer_id),
log_date DATE,
activity_type VARCHAR(50)
);

#Inserting data into customers
INSERT INTO customers (name, signup_date, country)
VALUES
('Alice Smith', '2023-01-10', 'USA'),
('Bob Lee', '2023-02-15', 'UK'),
('Charlie Kim', '2023-03-20', 'Canada'),
('Dana Lopez', '2023-04-01', 'USA');

#Inserting data into subscriptions
INSERT INTO subscriptions (customer_id, plan_type, start_date, end_date, is_cancelled)
VALUES
(1, 'Pro', '2023-01-10', '2023-06-10', TRUE),
(2, 'Basic', '2023-02-15', NULL, FALSE),
(3, 'Enterprise', '2023-03-20', '2023-06-01', TRUE),
(4, 'Basic', '2023-04-01', NULL, FALSE);

#Inserting data into activity_log
INSERT INTO activity_logs (customer_id, log_date, activity_type)
VALUES
(1, '2023-06-01', 'login'),
(1, '2023-05-15', 'purchase'),
(2, '2023-06-18', 'login'),
(3, '2023-05-01', 'login'),
(3, '2023-04-01', 'purchase'),
(4, '2023-06-18', 'login');

#Selecting churned/inactive customers:
SELECT 
	customers.customer_id, 
	name, 
	plan_type, 
	is_cancelled, 
	MAX(log_date) AS last_active,
	CASE
		WHEN is_cancelled = TRUE THEN 'Churned'
		WHEN MAX(log_date) < CURRENT_DATE - INTERVAL '60 DAYS' THEN 'Inactive(Churned)'
		ELSE 'Active'
	END AS status
FROM customers
INNER JOIN subscriptions on customers.customer_id = subscriptions.customer_id
LEFT JOIN activity_logs on customers.customer_id = activity_logs.customer_id
GROUP BY customers.customer_id, name, plan_type, is_cancelled;

#Selecting monthly churn count:
SELECT 
	DATE_TRUNC ('month', end_date) AS month,
	COUNT(*) AS churned_customers
FROM subscriptions
WHERE is_cancelled = TRUE
GROUP BY month
ORDER BY month;

#Selecting churn rate in pct by sub_plan
SELECT 
	plan_type,
	COUNT(*) FILTER (WHERE is_cancelled = TRUE) as churned,
	COUNT(*) AS total,
	ROUND(COUNT(*) FILTER (WHERE is_cancelled = TRUE) * 100 / COUNT(*),2) AS churn_rate_pct
FROM subscriptions
GROUP BY plan_type;
