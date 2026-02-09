-- ============================================================
-- SaaS Product Analytics -- PostgreSQL Setup
-- Description: Table Creation for PostgreSQL on Mac
-- ============================================================

-- 1. Create the Database (Run this separately if needed)
-- CREATE DATABASE saas_analytics;

-- 2. Create Users Table
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY,
    signup_date TEXT, -- Kept as text initially for cleaning
    plan_type TEXT,
    country TEXT,
    industry TEXT,
    acquisition_channel TEXT
);

-- 3. Create Sessions Table
CREATE TABLE IF NOT EXISTS sessions (
    session_id INT PRIMARY KEY,
    user_id INT,
    date TEXT,
    duration_minutes FLOAT,
    device_type TEXT
);

-- 4. Create Feature Usage Table
CREATE TABLE IF NOT EXISTS feature_usage (
    user_id INT,
    feature_name TEXT,
    usage_count INT,
    date TEXT
);

-- 5. Create Subscriptions Table
CREATE TABLE IF NOT EXISTS subscriptions (
    user_id INT,
    plan_start_date TEXT,
    plan_end_date TEXT,
    churned TEXT,
    MRR FLOAT
);

-- ============================================================
-- IMPORT INSTRUCTIONS
-- ============================================================
-- After creating tables, use the following commands to import your CSVs.
-- Replace '/PATH/TO/YOUR/FOLDER/' with your actual project path.

/*
COPY users FROM '/Users/praptimaheshwari/Desktop/Saas Project /SaaS-Product-Analytics-Dashboard/data/users.csv' WITH (FORMAT csv, HEADER true);
COPY sessions FROM '/Users/praptimaheshwari/Desktop/Saas Project /SaaS-Product-Analytics-Dashboard/data/sessions.csv' WITH (FORMAT csv, HEADER true);
COPY feature_usage FROM '/Users/praptimaheshwari/Desktop/Saas Project /SaaS-Product-Analytics-Dashboard/data/feature_usage.csv' WITH (FORMAT csv, HEADER true);
COPY subscriptions FROM '/Users/praptimaheshwari/Desktop/Saas Project /SaaS-Product-Analytics-Dashboard/data/subscriptions.csv' WITH (FORMAT csv, HEADER true);
*/
