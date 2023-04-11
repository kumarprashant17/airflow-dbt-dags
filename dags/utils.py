from airflow.models import Variable
from airflow.operators.bash import BashOperator

cluster_env = Variable.get('environment')

CMD = "/home/airflow/.local/bin/dbt"
DBT_CONFIG_DIR = f"/opt/airflow/dbt/config"
DBT_PROJECT_DIR = f"/opt/airflow/dbt/jaffle_shop/"


def create_dbt_task(dag, node, dbt_verb, dbt_vars="{}"):
    """Returns an Airflow operator either run and test an individual model"""
    cli_flags = "--no-write-json"
    model = node.split(".")[-1]
    if dbt_verb == "run":
        dbt_task = BashOperator(
            task_id=node,
            bash_command=' '.join([
                CMD, cli_flags, dbt_verb,
                "--target", cluster_env,
                "--models", model,
                "--profiles-dir", DBT_CONFIG_DIR,
                "--project-dir", DBT_PROJECT_DIR,
                "--vars", f"'{dbt_vars}'"
            ]),
            dag=dag
        )
    elif dbt_verb == "test":
        node_test = node.replace("model", "test")
        dbt_task = BashOperator(
            task_id=node_test,
            bash_command=' '.join([
                CMD, cli_flags, dbt_verb,
                "--target", cluster_env,
                "--models", model,
                "--profiles-dir", DBT_CONFIG_DIR,
                "--project-dir", DBT_PROJECT_DIR,
                "--vars", f"'{dbt_vars}'"
            ]),
            dag=dag
        )
    return dbt_task
