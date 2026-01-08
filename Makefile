# --- Configuration ---
PYTHON = python
MANAGE = $(PYTHON) manage.py
DOCKER_COMPOSE = docker-compose
APP_SERVICE = web

.PHONY: help setup up down build restart migrate freeze logs shell clean

# --- Help ---
help:
	@echo "Available commands:"
	@echo "  make setup     : Initialize environment and .env"
	@echo "  make up        : Start containers and stream logs"
	@echo "  make down      : Stop and remove containers"
	@echo "  make build     : Rebuild Docker images without cache"
	@echo "  make migrate   : Run Django migrations inside Docker"
	@echo "  make logs      : Tail Django logs"
	@echo "  make freeze    : Export clean requirements.txt"
	@echo "  make shell     : Enter Django shell inside Docker"

# --- Local Development & Security ---
setup:
	@if [ ! -f .env ]; then \
		echo "Creating .env from template..."; \
		echo "DB_NAME=lineage\nDB_USER=imireallan\nDB_ROOT_PASSWORD=root_pass\nDB_PASSWORD=app_pass\nDB_HOST=db\nDB_PORT=3306\nDEBUG=True\nSECRET_KEY=$(shell python3 -c 'import secrets; print(secrets.token_urlsafe(32))')" > .env; \
		echo ".env created. Edit it, then run 'make up'."; \
	else \
		echo ".env already exists."; \
	fi

freeze:
	pip freeze | grep -v " @ file://" > requirements.txt

# --- Docker Orchestration ---
# Starts containers and immediately attaches to logs
up:
	$(DOCKER_COMPOSE) up -d
	$(DOCKER_COMPOSE) logs -f $(APP_SERVICE)

down:
	$(DOCKER_COMPOSE) down

build:
	$(DOCKER_COMPOSE) build --no-cache

restart:
	$(DOCKER_COMPOSE) restart
	$(DOCKER_COMPOSE) logs -f $(APP_SERVICE)

logs:
	$(DOCKER_COMPOSE) logs -f $(APP_SERVICE)

# --- Django Commands (Executed inside Container) ---
migrate:
	$(DOCKER_COMPOSE) exec $(APP_SERVICE) python manage.py makemigrations
	$(DOCKER_COMPOSE) exec $(APP_SERVICE) python manage.py migrate

shell:
	$(DOCKER_COMPOSE) exec $(APP_SERVICE) python manage.py shell

# --- Utility ---
clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	rm -rf .pytest_cache
	rm -rf .DS_Store