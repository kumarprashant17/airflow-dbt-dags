FROM apache/airflow:2.2.1-python3.9

ARG AIRFLOW_VERSION=2.2.1
ARG PYTHON_VERSION=3.9

ARG AIRFLOW_DEPS=""
ARG PYTHON_DEPS=""

ARG USER=airflow
ARG AIRFLOW_HOME=/opt/airflow

RUN mkdir "$AIRFLOW_HOME/dbt"
RUN chown -R "airflow" "$AIRFLOW_HOME/dbt"

RUN pip install apache-airflow[crypto,postgres,jdbc,ssh,kubernetes${AIRFLOW_DEPS:+,}${AIRFLOW_DEPS}]==${AIRFLOW_VERSION} \
    # plyvel Required by airflow, unknown why not installed as a dependency
    && pip install plyvel==1.3.0 \
    && if [ -n "${PYTHON_DEPS}" ]; then pip install ${PYTHON_DEPS}; fi

COPY requirements/local.txt /requirements.txt
COPY script/entrypoint.sh /entrypoint.sh
COPY script/waitforwebserver.sh /waitforwebserver.sh
RUN mkdir -p /opt/airflow/dags/static
COPY ./dags "${AIRFLOW_HOME}/dags"
COPY ./dbt "${AIRFLOW_HOME}/dbt"
ENTRYPOINT ["/entrypoint.sh"]