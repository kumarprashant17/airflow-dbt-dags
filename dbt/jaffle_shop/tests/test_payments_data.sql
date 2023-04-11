SELECT 1
WHERE ( SELECT COUNT(*) FROM {{ source('payment_info', 'payments') }}
        WHERE created >= '{{ var("data_interval_start_incl") }}'
    AND created < '{{ var("data_interval_end_excl") }}') = 0
