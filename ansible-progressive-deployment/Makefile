.DEFAULT_GOAL := run

DOCKER_IMAGE ?= docker.io/v1v1v/anti-fraud:latest
CONTAINER_REGISTRY_USERNAME ?=
CONTAINER_REGISTRY_PASSWORD ?=
OTEL_EXPORTER_OTLP_ENDPOINT ?= localhost:4317
OTEL_EXPORTER_OTLP_INSECURE ?= true

VENV ?= .venv
PYTHON ?= python3
PIP ?= pip3

## @help:virtualenv:Create a Python virtual environment.
.PHONY: virtualenv
virtualenv:
	$(PYTHON) --version
	test -d $(VENV) || virtualenv -q --python=$(PYTHON) $(VENV);\
	source $(VENV)/bin/activate;\
	$(PIP) install -r requirements.txt;

## @help:prepare:Intall the ansible collection community.general.
.PHONY: prepare
prepare: virtualenv
	source $(VENV)/bin/activate;\
		echo "ansible-galaxy collection install community.general"

.PHONY: progressive-deployment
progressive-deployment:
	source $(VENV)/bin/activate;\
		ansible-playbook \
			progressive-deployment.yml \
			--extra-vars "default_container_image=$(DOCKER_IMAGE) docker_user=$(CONTAINER_REGISTRY_USERNAME) docker_password=$(CONTAINER_REGISTRY_PASSWORD)"

.PHONY: production
production:
	source $(VENV)/bin/activate;\
		ansible-playbook \
			production.yml \
			--extra-vars "default_container_image=$(DOCKER_IMAGE) docker_user=$(CONTAINER_REGISTRY_USERNAME) docker_password=$(CONTAINER_REGISTRY_PASSWORD)"

.PHONY: run-with-otel
run-with-otel:
	source $(VENV)/bin/activate;\
	OTEL_EXPORTER_OTLP_INSECURE=$(OTEL_EXPORTER_OTLP_INSECURE) \
	OTEL_EXPORTER_OTLP_ENDPOINT=$(OTEL_EXPORTER_OTLP_ENDPOINT) \
	ansible-playbook progressive-deployment.yml --extra-vars "default_container_image=$(DOCKER_IMAGE)"
