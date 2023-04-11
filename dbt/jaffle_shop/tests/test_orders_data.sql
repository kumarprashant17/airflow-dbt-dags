SELECT 1
WHERE ( SELECT COUNT(*) FROM {{ source('datalake', 'orders') }}
        WHERE order_date >= '{{ var("data_interval_start_incl") }}'
    AND order_date < '{{ var("data_interval_end_excl") }}') = 0
