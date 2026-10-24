DBT = DBT_PROFILES_DIR=. ../.venv/bin/dbt
CLIENT = docker compose exec -T clickhouse clickhouse-client --user hw4 --password local-demo-password

.PHONY: setup up load deps run test build lint docs serve stop

setup:
	uv venv --python 3.12 .venv
	uv pip install --python .venv/bin/python -r requirements.txt

up:
	docker compose up -d --wait

load:
	test -f data/train.csv
	$(CLIENT) --query 'truncate table transactions_db.transactions'
	$(CLIENT) \
	    --date_time_input_format=best_effort \
	    --max_insert_block_size=16384 \
	    --input_format_parallel_parsing=0 \
	    --query 'insert into transactions_db.transactions format CSVWithNames' \
	    < data/train.csv

deps run test build:
	cd dbt && $(DBT) $@

lint:
	cd dbt && ../.venv/bin/sqlfluff lint models tests

docs:
	cd dbt && $(DBT) docs generate

serve:
	cd dbt && $(DBT) docs serve --host 127.0.0.1 --port 8082 --no-browser

stop:
	docker compose stop
