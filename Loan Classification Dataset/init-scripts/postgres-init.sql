-- Create the metabase database if it does not exist
CREATE DATABASE metabase;

-- Connect to the loan_gold_db
\c loan_gold_db;

-- Example: Create a gold table for ML model training
CREATE TABLE IF NOT EXISTS gold_loan_features (
    id SERIAL PRIMARY KEY,
    loan_id VARCHAR(50) UNIQUE NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    annual_income_normalized FLOAT,
    credit_score_bucket VARCHAR(20),
    debt_to_income_ratio FLOAT,
    loan_term_months INT,
    interest_rate FLOAT,
    loan_status VARCHAR(20) -- Target variable: 'Paid', 'Defaulted'
);
