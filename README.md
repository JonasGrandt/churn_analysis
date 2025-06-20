# Customer Churn Analysis with PostgreSQL & R

Welcome! This project analyzes customer churn patterns using a PostgreSQL database and R for data wrangling and visualization.
Note: the goal for this project is not to produce relevant data, but for me to practice and share multiplatform coding and good data practice.

## 📌 Project Overview

This repository demonstrates how to:
- Set up a relational database for customer data
- Query churn behavior and activity using SQL
- Connect R to a PostgreSQL database
- Visualize churn status by subscription plan using `ggplot2`

---

## 🗂 Project Structure
churn_analysis/
├── data/
│ └── create_tables.sql 
|   └── data inserts + analysis queries
├── R/
│ └── churn_analysis.R 
|   └── DB connection + queries + visualization
├── .Renviron.example # Template for DB credentials (NOT real creds)
├── .gitignore # Ignores sensitive or system files
└── README.md 

---

## Create Your PostgreSQL Database
#Open your terminal or preferred SQL client and run:
CREATE DATABASE churn_analysis;

#Then, load the schema and sample data using:
psql -d churn_analysis -f data/create_tables.sql

#This will: Create three tables: customers, subscriptions, and activity_logs

## Configure Environment Variables in R
#Copy the example environment file:
cp .Renviron.example .Renviron

#Open .Renviron in your text editor and fill in your PostgreSQL credentials:
DB_NAME=churn_analysis
DB_HOST=localhost
DB_PORT=5432
DB_USER=your_username
DB_PASSWORD=your_password

#Restart RStudio or reload the environment file using
readRenviron("~/.Renviron")

## Make sure these R packages are installed:
install.packages(c("DBI", "RPostgres", "dplyr", "ggplot2", "lubridate"))

## This project is for self learning

