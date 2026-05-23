-- Create Gold ML Features Table
DROP TABLE IF EXISTS gold_ml_features;
CREATE TABLE gold_ml_features AS
SELECT 
    f.loan_id, 
    f.member_id, 
    f.funded_amnt, 
    f.loan_status,
    b.emp_length, 
    b.home_ownership, 
    b.annual_inc, 
    b.addr_state,
    l.term, 
    l.int_rate, 
    l.grade, 
    l.purpose,
    c.dti, 
    c.fico_range_low, 
    c.revol_util
FROM stg_fact_loan_performance f
LEFT JOIN stg_dim_borrower b ON f.member_id = b.member_id
LEFT JOIN stg_dim_loan_info l ON f.loan_id = l.loan_id
LEFT JOIN stg_dim_credit_profile c ON f.member_id = c.member_id;

-- Create Gold Analytics Summary Table
DROP TABLE IF EXISTS gold_analytics_state_summary;
CREATE TABLE gold_analytics_state_summary AS
SELECT 
    addr_state,
    COUNT(loan_id) as total_loans,
    AVG(CAST(funded_amnt AS NUMERIC)) as avg_funded_amnt,
    AVG(CAST(int_rate AS NUMERIC)) as avg_int_rate
FROM gold_ml_features
WHERE addr_state IS NOT NULL
GROUP BY addr_state;
