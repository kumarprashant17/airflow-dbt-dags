{{ config(
        materialized='incremental',
        sort='created',
        pre_hook='delete from {{ this }} where created >= \'{{ var("data_interval_start_incl") }}\'  AND created < \'{{ var("data_interval_end_excl") }}\''
    ) }}

select
    id as payment_id,
    orderid as order_id,
    paymentmethod,
    status,
    amount,
    created
from {{ source('payment_info', 'payments') }}
{% if is_incremental() %}
    where created >= '{{ var("data_interval_start_incl") }}'
    and created < '{{ var("data_interval_end_excl") }}'
{% endif %}