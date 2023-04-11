select
        id as customer_id,
        first_name,
        last_name,
        {{ concat_name(first_name, last_name) }} AS full_name
from prashant_dbt.datalake.customers