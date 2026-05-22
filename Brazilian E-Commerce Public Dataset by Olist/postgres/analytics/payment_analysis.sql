-- =============================================================================
-- payment_analysis.sql
-- Nguồn: warehouse.fact_payments
-- =============================================================================

CREATE OR REPLACE VIEW analytics.vw_payment_analysis AS
SELECT
    fp.payment_type                             AS payment_type,
    COUNT(DISTINCT fp.order_id)                 AS total_orders,
    COALESCE(SUM(fp.payment_value), 0)          AS total_payment_value,
    COALESCE(AVG(fp.payment_installments), 0)   AS avg_installments
FROM warehouse.fact_payments fp
GROUP BY fp.payment_type;