
{{ config(
        materialized='incremental',
        pre_hook='delete from {{ this }} where order_date >= \'{{ var("data_interval_start_incl") }}\'  AND order_date < \'{{ var("data_interval_end_excl") }}\''
    ) }}



with final as (
                select full_name,
                      order_date,
                      status,
                      amount
               from  {{ ref('customers_data') }} as c_data
                        left join {{ ref('orders_data') }} as o_data using (customer_id)
                        left join {{ ref('payments_data') }} as p_data using (order_id)
                where
                    status = 'completed'
                {% if is_incremental() %}
                    and order_date >= '{{ var("data_interval_start_incl") }}'
                    and order_date < '{{ var("data_interval_end_excl") }}'
                {% endif %}
            )

select * from final