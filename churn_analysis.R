library(DBI)
library(RPostgres)
library(dplyr)
library(ggplot2)
library(lubridate)

con <- dbConnect(
  RPostgres::Postgres(),
  dbname = Sys.getenv("DB_NAME"),
  host = Sys.getenv("DB_HOST"),
  port = as.integer(Sys.getenv("DB_PORT")),
  user = Sys.getenv("DB_USER"),
  password = Sys.getenv("DB_PASSWORD")
)

query <- "
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
"

churn_data <- dbGetQuery(con,query)

ggplot(churn_data, aes (x = status,fill = plan_type)) +
  geom_bar(position = "dodge") +
  labs (title = "Customer Status by Plan Type",
    x= "Status", y= "count")
theme_minimal()

