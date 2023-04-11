{{ config(
        materialized='incremental',
        sort='order_date',
        pre_hook='delete from {{ this }} where order_date >= \'{{ var("data_interval_start_incl") }}\'  AND order_date < \'{{ var("data_interval_end_excl") }}\''
    ) }}


select
    id as order_id,
    user_id as customer_id,
    order_date,
    status
from {{ source('datalake', 'orders') }}
{% if is_incremental() %}
    WHERE order_date >= '{{ var("data_interval_start_incl") }}'
    AND order_date < '{{ var("data_interval_end_excl") }}'
{% endif %}