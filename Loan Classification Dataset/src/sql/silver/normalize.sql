-- Clear existing data
TRUNCATE TABLE dim_borrower;
TRUNCATE TABLE dim_loan_info;
TRUNCATE TABLE dim_credit_profile;
TRUNCATE TABLE fact_loan_performance;

-- Insert into dim_borrower
INSERT INTO dim_borrower (member_id, emp_title, emp_length, home_ownership, annual_inc, zip_code, addr_state)
SELECT DISTINCT
    COALESCE(raw_data->>'$.member_id', CONCAT('M_', id)) AS member_id,
    raw_data->>'$.emp_title',
    raw_data->>'$.emp_length',
    raw_data->>'$.home_ownership',
    CAST(raw_data->>'$.annual_inc' AS DECIMAL(15,2)),
    raw_data->>'$.zip_code',
    raw_data->>'$.addr_state'
FROM bronze_loans_raw;

-- Insert into dim_loan_info
INSERT INTO dim_loan_info (loan_id, term, int_rate, installment, grade, sub_grade, purpose, title, issue_d)
SELECT DISTINCT
    COALESCE(raw_data->>'$.id', CONCAT('L_', id)) AS loan_id,
    raw_data->>'$.term',
    CAST(raw_data->>'$.int_rate' AS DECIMAL(10,4)),
    CAST(raw_data->>'$.installment' AS DECIMAL(15,2)),
    raw_data->>'$.grade',
    raw_data->>'$.sub_grade',
    raw_data->>'$.purpose',
    raw_data->>'$.title',
    raw_data->>'$.issue_d'
FROM bronze_loans_raw;

-- Insert into dim_credit_profile
INSERT INTO dim_credit_profile (member_id, dti, earliest_cr_line, fico_range_low, fico_range_high, open_acc, pub_rec, revol_bal, revol_util, total_acc)
SELECT DISTINCT
    COALESCE(raw_data->>'$.member_id', CONCAT('M_', id)) AS member_id,
    CAST(raw_data->>'$.dti' AS DECIMAL(10,4)),
    raw_data->>'$.earliest_cr_line',
    CAST(raw_data->>'$.fico_range_low' AS UNSIGNED),
    CAST(raw_data->>'$.fico_range_high' AS UNSIGNED),
    CAST(raw_data->>'$.open_acc' AS UNSIGNED),
    CAST(raw_data->>'$.pub_rec' AS UNSIGNED),
    CAST(raw_data->>'$.revol_bal' AS DECIMAL(15,2)),
    CAST(raw_data->>'$.revol_util' AS DECIMAL(10,4)),
    CAST(raw_data->>'$.total_acc' AS UNSIGNED)
FROM bronze_loans_raw;

-- Insert into fact_loan_performance
INSERT INTO fact_loan_performance (loan_id, member_id, funded_amnt, out_prncp, total_pymnt, total_rec_prncp, total_rec_int, last_pymnt_d, last_pymnt_amnt, loan_status)
SELECT
    COALESCE(raw_data->>'$.id', CONCAT('L_', id)) AS loan_id,
    COALESCE(raw_data->>'$.member_id', CONCAT('M_', id)) AS member_id,
    CAST(raw_data->>'$.funded_amnt' AS DECIMAL(15,2)),
    CAST(raw_data->>'$.out_prncp' AS DECIMAL(15,2)),
    CAST(raw_data->>'$.total_pymnt' AS DECIMAL(15,2)),
    CAST(raw_data->>'$.total_rec_prncp' AS DECIMAL(15,2)),
    CAST(raw_data->>'$.total_rec_int' AS DECIMAL(15,2)),
    raw_data->>'$.last_pymnt_d',
    CAST(raw_data->>'$.last_pymnt_amnt' AS DECIMAL(15,2)),
    raw_data->>'$.loan_status'
FROM bronze_loans_raw;
