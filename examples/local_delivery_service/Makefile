# DBT_VARS_FILE ?= vars.yml
# DBT_VARS ?=$(shell yq eval ${DBT_VARS_FILE} -o json | jq -cM)

lint-sql:
	poetry run sqlfluff lint models

compile:
	poetry run dbt compile ${ARGS}

clean:
	poetry run dbt clean
