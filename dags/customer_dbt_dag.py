import pendulum

from airflow import DAG
from datetime import timedelta

from airflow.operators.dummy_operator import DummyOperator

from utils import create_dbt_task

dagargs = {
            'default_args': {
                'owner': 'Prashant Kumar',
                'depends_on_past': False,
                'email_on_failure': False,
                'email_on_retry': False,
                'retries': 4,
                'retry_delay': timedelta(minutes=1)
                },
            'start_date': pendulum.datetime(2022, 11, 5, tz="UTC")
        }


dag_settings = {
        "max_active_runs": 1,
        "concurrency": 2,
        "catchup": False,
        "schedule_interval": None,
        "tags": ["customer_dbt", "dbt"],
        }

dagargs.update(**dag_settings)

dag = DAG("customer_dbt_dag", **dagargs)

start = DummyOperator(task_id='start', dag=dag)
end = DummyOperator(task_id='end', dag=dag)

customers_data_task = create_dbt_task(dag, "customers_data", "test", dbt_vars="{}")

start >> customers_data_task >> end