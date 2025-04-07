all:
	@echo "make HELP"
	@echo ""

ifndef SERVICE
SERVICE:=cln-to-stdout
endif

DC:=docker compose
DC_RUN=$(DC) run --rm $(SERVICE)

build:
	$(DC) --progress plain build

down:
	$(DC) down --remove-orphans

destroy: down
	$(DC) down -v

shell:
	$(DC_RUN) sh

up:
	$(DC) up $(SERVICE)
