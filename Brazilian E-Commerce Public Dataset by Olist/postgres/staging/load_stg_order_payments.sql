-- TT
TRUNCATE TABLE staging.stg_order_payments;

-- II 
INSERT INTO staging.stg_order_payments (
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    CAST(op.order_id AS UUID),
    CAST(op.payment_sequential AS INTEGER),
    LOWER(TRIM(op.payment_type)),
    CAST(op.payment_installments AS INTEGER),
    CAST(op.payment_value AS DECIMAL(12, 2))
FROM raw.olist_order_payments_dataset AS op
WHERE op.order_id IS NOT NULL 
  AND op.payment_type IS NOT NULL;