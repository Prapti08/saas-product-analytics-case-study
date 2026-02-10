-- ============================================================
-- SaaS Product Analytics -- PostgreSQL Export Script
-- Description: Export Cleaned Data to CSV for Power BI Browser
-- ============================================================

\copy users TO '/Users/praptimaheshwari/Desktop/Saas Project /SaaS-Product-Analytics-Dashboard/data/users_clean.csv' WITH (FORMAT csv, HEADER true);
\copy sessions TO '/Users/praptimaheshwari/Desktop/Saas Project /SaaS-Product-Analytics-Dashboard/data/sessions_clean.csv' WITH (FORMAT csv, HEADER true);
\copy feature_usage TO '/Users/praptimaheshwari/Desktop/Saas Project /SaaS-Product-Analytics-Dashboard/data/feature_usage_clean.csv' WITH (FORMAT csv, HEADER true);
\copy subscriptions TO '/Users/praptimaheshwari/Desktop/Saas Project /SaaS-Product-Analytics-Dashboard/data/subscriptions_clean.csv' WITH (FORMAT csv, HEADER true);
