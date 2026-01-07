# Variables
PYTHON = python
MANAGE = $(PYTHON) manage.py

.PHONY: setup migrate run shell clean

# Check if .env exists, if not, create a template
setup:
	@if [ ! -f .env ]; then \
		echo "Creating .env from template..."; \
		echo "DB_NAME=lineage\nDB_USER=root\nDB_PASSWORD=12345\nDB_HOST=127.0.0.1\nDB_PORT=3306" > .env; \
	fi
	conda config --add channels conda-forge
	conda install -y mysqlclient
	pip install django django-filter django-cors-headers graphene-django python-dotenv
	@echo "Setup complete. Please update your .env file with your DB credentials."

migrate:
	$(MANAGE) makemigrations
	$(MANAGE) migrate

run:
	$(MANAGE) runserver

shell:
	$(MANAGE) shell

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	rm -rf .pytest_cache