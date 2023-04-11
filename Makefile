CONTAINER_NAME=dbt_dags

stopenv:
	@docker-compose -f docker-compose.yml down --remove-orphans

startenv: stopenv
	@docker-compose -f docker-compose.yml up --build -d
	@docker exec ${CONTAINER_NAME} /waitforwebserver.sh
