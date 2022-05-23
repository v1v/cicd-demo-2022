.DEFAULT_GOAL := run

DOCKER_IMAGE ?= docker.io/v1v1v/anti-fraud
DOCKER_IMAGE_VERSION ?= latest
CONTAINER_REGISTRY_USR ?=
CONTAINER_REGISTRY_PSW ?=
KIBANA_USR ?= admin
KIBANA_PSW ?= changeme
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
	echo "Use https://github.com/ansible-collections/community.general/pull/4175"
	mkdir -p callback_plugins
	curl -s https://raw.githubusercontent.com/ansible-collections/community.general/843d04adf3c4814bf5ac0f4ff7ace24d74ff5e7e/plugins/callback/opentelemetry.py > callback_plugins/opentelemetry.py

.PHONY: deploy-canary
deploy-canary:
	source $(VENV)/bin/activate;\
		ansible-playbook \
			deploy-canary.yml \
			--extra-vars "default_container_image=$(DOCKER_IMAGE) version=$(DOCKER_IMAGE_VERSION) docker_user=$(CONTAINER_REGISTRY_USR) docker_password=$(CONTAINER_REGISTRY_PSW) kibana_user=$(KIBANA_USR) kibana_password=$(KIBANA_PSW)"

.PHONY: deploy-full-environment
deploy-full-environment:
	source $(VENV)/bin/activate;\
		ansible-playbook \
			deploy-full-environment.yml \
			--extra-vars "default_container_image=$(DOCKER_IMAGE) version=$(DOCKER_IMAGE_VERSION) docker_user=$(CONTAINER_REGISTRY_USR) docker_password=$(CONTAINER_REGISTRY_PSW) kibana_user=$(KIBANA_USR) kibana_password=$(KIBANA_PSW)"

.PHONY: rollback
rollback:
	source $(VENV)/bin/activate;\
		ansible-playbook \
			rollback.yml \
			--extra-vars "default_container_image=$(DOCKER_IMAGE) version=$(DOCKER_IMAGE_VERSION) docker_user=$(CONTAINER_REGISTRY_USR) docker_password=$(CONTAINER_REGISTRY_PSW) kibana_user=$(KIBANA_USR) kibana_password=$(KIBANA_PSW)"

.PHONY: healthcheck
healthcheck:
	source $(VENV)/bin/activate;\
		ansible-playbook \
			healthcheck.yml \
			--extra-vars "default_container_image=$(DOCKER_IMAGE) version=$(DOCKER_IMAGE_VERSION) docker_user=$(CONTAINER_REGISTRY_USR) docker_password=$(CONTAINER_REGISTRY_PSW) kibana_user=$(KIBANA_USR) kibana_password=$(KIBANA_PSW)"

.PHONY: run-with-otel
run-with-otel:
	source $(VENV)/bin/activate;\
	OTEL_EXPORTER_OTLP_INSECURE=$(OTEL_EXPORTER_OTLP_INSECURE) \
	OTEL_EXPORTER_OTLP_ENDPOINT=$(OTEL_EXPORTER_OTLP_ENDPOINT) \
	ansible-playbook progressive-deployment.yml --extra-vars "default_container_image=$(DOCKER_IMAGE) version=$(DOCKER_IMAGE_VERSION) docker_user=$(CONTAINER_REGISTRY_USR) docker_password=$(CONTAINER_REGISTRY_PSW) kibana_user=$(KIBANA_USR) kibana_password=$(KIBANA_PSW)"

.PHONY: demo
demo: virtualenv
	source $(VENV)/bin/activate;\
		ansible-playbook demo.yml --extra-vars "kibana_user=$(KIBANA_USR) kibana_password=$(KIBANA_PSW)"
