-- =============================================================================
-- fact_payments.sql
-- Load: staging.stg_order_payments → warehouse.fact_payments
-- Grain: 1 row / (order_id, payment_sequential)
-- Dependency: fact_orders phải load trước
-- =============================================================================

INSERT INTO warehouse.fact_payments (
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    p.order_id,
    p.payment_sequential,
    p.payment_type,
    p.payment_installments,
    p.payment_value
FROM staging.stg_order_payments p
WHERE EXISTS (
    SELECT 1 FROM warehouse.fact_orders fo WHERE fo.order_id = p.order_id
)
ON CONFLICT (order_id, payment_sequential) DO UPDATE
    SET payment_type         = EXCLUDED.payment_type,
        payment_installments = EXCLUDED.payment_installments,
        payment_value        = EXCLUDED.payment_value;
