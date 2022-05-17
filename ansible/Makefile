.DEFAULT_GOAL := run

DOCKER_IMAGE ?= docker.io/elasticobservability/demo-fosdem:0.0.1
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
		ansible-galaxy collection install community.general

.PHONY: run
run:
	source $(VENV)/bin/activate;\
		ansible-playbook playbook.yml --extra-vars "default_container_image=$(DOCKER_IMAGE)"

.PHONY: run-with-otel
run-with-otel:
	source $(VENV)/bin/activate;\
	OTEL_EXPORTER_OTLP_INSECURE=$(OTEL_EXPORTER_OTLP_INSECURE) \
	OTEL_EXPORTER_OTLP_ENDPOINT=$(OTEL_EXPORTER_OTLP_ENDPOINT) \
	ansible-playbook playbook.yml --extra-vars "default_container_image=$(DOCKER_IMAGE)"
