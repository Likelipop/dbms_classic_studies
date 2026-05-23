-- MySQL Initialization Script for Bronze and Silver Layers

CREATE DATABASE IF NOT EXISTS loan_db;
USE loan_db;

-- Bronze Layer
DROP TABLE IF EXISTS bronze_loans_raw;
CREATE TABLE IF NOT EXISTS bronze_loans_raw (
    id INT AUTO_INCREMENT PRIMARY KEY,
    raw_data JSON,
    imported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Silver Layer (BCNF Normalized)
DROP TABLE IF EXISTS fact_loan_performance;
DROP TABLE IF EXISTS dim_borrower;
DROP TABLE IF EXISTS dim_loan_info;
DROP TABLE IF EXISTS dim_credit_profile;

CREATE TABLE IF NOT EXISTS dim_borrower (
    member_id VARCHAR(50) PRIMARY KEY,
    emp_title TEXT,
    emp_length VARCHAR(50),
    home_ownership VARCHAR(20),
    annual_inc FLOAT,
    zip_code VARCHAR(10),
    addr_state VARCHAR(5)
);

CREATE TABLE IF NOT EXISTS dim_loan_info (
    loan_id VARCHAR(50) PRIMARY KEY,
    term VARCHAR(20),
    int_rate FLOAT,
    installment FLOAT,
    grade VARCHAR(5),
    sub_grade VARCHAR(5),
    purpose VARCHAR(50),
    title TEXT,
    issue_d VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS dim_credit_profile (
    member_id VARCHAR(50) PRIMARY KEY,
    dti FLOAT,
    earliest_cr_line VARCHAR(20),
    fico_range_low INT,
    fico_range_high INT,
    open_acc INT,
    pub_rec INT,
    revol_bal FLOAT,
    revol_util FLOAT,
    total_acc INT
);

CREATE TABLE IF NOT EXISTS fact_loan_performance (
    loan_id VARCHAR(50),
    member_id VARCHAR(50),
    funded_amnt FLOAT,
    out_prncp FLOAT,
    total_pymnt FLOAT,
    total_rec_prncp FLOAT,
    total_rec_int FLOAT,
    last_pymnt_d VARCHAR(20),
    last_pymnt_amnt FLOAT,
    loan_status VARCHAR(50),
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(loan_id, member_id)
);
