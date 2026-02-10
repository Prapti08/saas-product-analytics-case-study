-- ============================================================
-- SaaS Product Analytics -- PostgreSQL Cleaning Script
-- Description: Ported from SQL Server to PostgreSQL
-- ============================================================

-- ------------------------------------------------------------
-- 1. USERS TABLE CLEANING
-- ------------------------------------------------------------

-- Standardize plan_type and fill NULLs
UPDATE users 
SET plan_type = COALESCE(LOWER(TRIM(plan_type)), 'free');

-- Fill NULL acquisition_channel
UPDATE users 
SET acquisition_channel = COALESCE(acquisition_channel, 'unknown');

-- Create Clean Date Column
ALTER TABLE users ADD COLUMN signup_date_clean DATE;

-- Fix Mixed Date Formats
UPDATE users
SET signup_date_clean = CASE 
    WHEN signup_date ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(signup_date, 'YYYY-MM-DD')
    WHEN signup_date ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN TO_DATE(signup_date, 'MM/DD/YYYY')
    WHEN signup_date ~ '^\d{1,2}-\d{1,2}-\d{4}$' THEN TO_DATE(signup_date, 'DD-MM-YYYY')
    ELSE NULL
END;

-- ------------------------------------------------------------
-- 2. SESSIONS TABLE CLEANING
-- ------------------------------------------------------------

-- Add Clean Date and Fill NULLs
ALTER TABLE sessions ADD COLUMN date_clean DATE;

UPDATE sessions
SET device_type = COALESCE(device_type, 'unknown'),
    duration_minutes = COALESCE(duration_minutes, 61),
    date_clean = CASE 
        WHEN date ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(date, 'YYYY-MM-DD')
        WHEN date ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN TO_DATE(date, 'MM/DD/YYYY')
        WHEN date ~ '^\d{1,2}-\d{1,2}-\d{4}$' THEN TO_DATE(date, 'DD-MM-YYYY')
        ELSE NULL
    END;

-- Remove Duplicate Sessions
DELETE FROM sessions
WHERE session_id NOT IN (
    SELECT MIN(session_id)
    FROM sessions
    GROUP BY user_id, date, device_type
);

-- ------------------------------------------------------------
-- 3. SUBSCRIPTIONS TABLE CLEANING
-- ------------------------------------------------------------

ALTER TABLE subscriptions ADD COLUMN plan_start_clean DATE;
ALTER TABLE subscriptions ADD COLUMN plan_end_clean DATE;

UPDATE subscriptions
SET churned = UPPER(TRIM(COALESCE(churned, 'N'))),
    plan_start_clean = CASE 
        WHEN plan_start_date ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(plan_start_date, 'YYYY-MM-DD')
        WHEN plan_start_date ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN TO_DATE(plan_start_date, 'MM/DD/YYYY')
        WHEN plan_start_date ~ '^\d{1,2}-\d{1,2}-\d{4}$' THEN TO_DATE(plan_start_date, 'DD-MM-YYYY')
        ELSE NULL
    END,
    plan_end_clean = CASE 
        WHEN plan_end_date ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(plan_end_date, 'YYYY-MM-DD')
        WHEN plan_end_date ~ '^\d{1,2}/\d{1,2}/\d{4}$' THEN TO_DATE(plan_end_date, 'MM/DD/YYYY')
        WHEN plan_end_date ~ '^\d{1,2}-\d{1,2}-\d{4}$' THEN TO_DATE(plan_end_date, 'DD-MM-YYYY')
        ELSE NULL
    END;

-- Impute MRR based on plan type
UPDATE subscriptions
SET MRR = CASE 
    WHEN MRR IS NOT NULL THEN MRR
    WHEN user_id IN (SELECT user_id FROM users WHERE plan_type = 'paid') THEN 59
    ELSE 0
END;
