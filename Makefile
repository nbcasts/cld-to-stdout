all: help

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

ifndef SERVICE
SERVICE:=cln-to-stdout
endif

DC:=docker compose
DC_RUN=$(DC) run --rm $(SERVICE)

build: Dockerfile ## build the container image
	$(DC) build

down: ## containers stop all
	$(DC) down --remove-orphans

destroy: ## containers stop all and destroy volumes
	$(DC) down --remove-orphans -v

shell: ## open a shell (zsh) inside the container
	$(DC_RUN) sh

up: ## start all services
	$(DC) up $(SERVICE)
