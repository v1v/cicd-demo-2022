.DEFAULT_GOAL := run

DOCKER_IMAGE ?= docker.io/v1v1v/anti-fraud
DOCKER_IMAGE_VERSION ?= latest
CONTAINER_REGISTRY ?=
CONTAINER_REGISTRY_PSW ?=
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
	echo "Use https://github.com/ansible-collections/community.general/pull/4104"
	mkdir -p callback_plugins
	curl -s https://raw.githubusercontent.com/ansible-collections/community.general/af15b205158143cc6da494aab3e16e0a5eef92df/plugins/callback/opentelemetry.py > callback_plugins/opentelemetry.py

.PHONY: progressive-deployment
progressive-deployment:
	source $(VENV)/bin/activate;\
		ansible-playbook \
			progressive-deployment.yml \
			--extra-vars "default_container_image=$(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION) docker_user=$(CONTAINER_REGISTRY) docker_password=$(CONTAINER_REGISTRY_PSW)"

.PHONY: production
production:
	source $(VENV)/bin/activate;\
		ansible-playbook \
			production.yml \
			--extra-vars "default_container_image=$(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION) docker_user=$(CONTAINER_REGISTRY) docker_password=$(CONTAINER_REGISTRY_PSW)"

.PHONY: rollback
rollback:
	source $(VENV)/bin/activate;\
		ansible-playbook \
			rollback.yml \
			--extra-vars "default_container_image=$(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION) docker_user=$(CONTAINER_REGISTRY) docker_password=$(CONTAINER_REGISTRY_PSW)"

.PHONY: healthcheck
healthcheck:
	source $(VENV)/bin/activate;\
		ansible-playbook \
			healthcheck.yml \
			--extra-vars "default_container_image=$(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION) docker_user=$(CONTAINER_REGISTRY) docker_password=$(CONTAINER_REGISTRY_PSW)"

.PHONY: run-with-otel
run-with-otel:
	source $(VENV)/bin/activate;\
	OTEL_EXPORTER_OTLP_INSECURE=$(OTEL_EXPORTER_OTLP_INSECURE) \
	OTEL_EXPORTER_OTLP_ENDPOINT=$(OTEL_EXPORTER_OTLP_ENDPOINT) \
	ansible-playbook progressive-deployment.yml --extra-vars "default_container_image=$(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION)"

.PHONY: demo
demo:
	source $(VENV)/bin/activate;\
		ansible-playbook demo.yml
