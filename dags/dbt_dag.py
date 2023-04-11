import pendulum
import json
from airflow import DAG
from datetime import timedelta

from airflow.operators.dummy_operator import DummyOperator

from utils import create_dbt_task  # this is a reusable function to create the airflow task for dbt˳


dagargs = {
            'default_args': {
                'owner': 'Prashant Kumar',
                'depends_on_past': False,
                'email_on_failure': False,
                'email_on_retry': False,
                'retries': 4,
                'retry_delay': timedelta(minutes=1)
                },
            'start_date': pendulum.datetime(2022, 11, 15, tz="UTC")
        }


dag_settings = {
        "max_active_runs": 1,
        "concurrency": 2,
        "catchup": False,
        "schedule_interval": "0 0 1 * *",
        "tags": ["demo", "dbt"],
        }

dagargs.update(**dag_settings)

dag = DAG("dbt_demo", **dagargs)
dbt_vars = {
    "data_interval_start_incl": "{{ data_interval_start.strftime('%Y-%m-%d %H:00:00') }}",
    "data_interval_end_excl": "{{ data_interval_end.strftime('%Y-%m-%d %H:00:00') }}",
}
dbt_vars_str = json.dumps(dbt_vars)

start = DummyOperator(task_id='start', dag=dag)
end = DummyOperator(task_id='end', dag=dag)


test_orders_data_task = create_dbt_task(dag, "test_orders_data", "test", dbt_vars=dbt_vars_str)
orders_data_task = create_dbt_task(dag, "orders_data", "run", dbt_vars=dbt_vars_str)
test_payments_data_task = create_dbt_task(dag, "test_payments_data", "test", dbt_vars=dbt_vars_str)
payments_data_task = create_dbt_task(dag, "payments_data", "run", dbt_vars=dbt_vars_str)
customer_orders_task = create_dbt_task(dag, "customer_orders", "run", dbt_vars=dbt_vars_str)

start >> test_orders_data_task >> orders_data_task >> test_payments_data_task >> payments_data_task >> customer_orders_task >> end

