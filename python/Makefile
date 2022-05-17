# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0

OTEL_EXPORTER_OTLP_ENDPOINT ?= http://127.0.0.1:4317
OTEL_SERVICE_NAME ?= "pytest_otel_test"
OTEL_EXPORTER_OTLP_INSECURE ?= True
OTEL_EXPORTER_OTLP_HEADERS ?=
TRACEPARENT ?=

HOST_TEST_URL ?= http://localhost:28080
SMOKE_TEST_URL ?= $(HOST_TEST_URL)/hello
KIBANA_URL ?= http://localhost:5601
KIBANA_USR ?= admin
KIBANA_PSW ?= changeme
HELLO_WORLD_IMAGE ?= docker.io/v1v1v/anti-fraud:0.0.1
VENV ?= .venv
PYTHON ?= python3
PIP ?= pip3
GH_VERSION = 1.0.0

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	OS_FLAG := linux
endif
ifeq ($(UNAME_S),Darwin)
	OS_FLAG := macOS
endif
UNAME_P := $(shell uname -m)
ifeq ($(UNAME_P),x86_64)
	ARCH_FLAG := amd64
endif
ifneq ($(filter %86,$(UNAME_P)),)
	ARCH_FLAG := i386
endif
GH_BINARY = gh_$(GH_VERSION)_$(OS_FLAG)_$(ARCH_FLAG)
GH = $(CURDIR)/bin/gh

.SILENT:

.PHONY: help
help:
	@echo "Targets:"
	@echo ""
	@grep '^## @help' Makefile|cut -d ":" -f 2-3|( (sort|column -s ":" -t) || (sort|tr ":" "\t") || (tr ":" "\t"))

## @help:virtualenv:Create a Python virtual environment.
.PHONY: virtualenv
virtualenv:
	$(PYTHON) --version
	test -d $(VENV) || virtualenv -q --python=$(PYTHON) $(VENV);\
	source $(VENV)/bin/activate;\
	$(PIP) install -q -r requirements.txt;

## @help:test:Run the test with the docker-compose.
.PHONY: test-with-docker-compose
test-with-docker-compose: virtualenv
	HELLO_WORLD_IMAGE=$(HELLO_WORLD_IMAGE) docker-compose up -d
	sleep 30
	$(MAKE) test
	docker-compose down

## @help:test:Run the test in the existing environment.
.PHONY: test
test: virtualenv
	source $(VENV)/bin/activate;\
	SMOKE_TEST_URL=$(SMOKE_TEST_URL) \
	pytest --capture=no \
		--otel-service-name $(OTEL_SERVICE_NAME) \
		--junitxml $(CURDIR)/junit-smoke-tests.xml \
		test_smoke.py

## @help:canary-health-check-with-elastic:Run a test to validate there is no errors on the end point.
.PHONY: canary-health-check-with-elastic
canary-health-check-with-elastic: virtualenv
	source $(VENV)/bin/activate;\
	HOST_TEST_URL=$(HOST_TEST_URL) \
	KIBANA_URL=$(KIBANA_URL) \
	KIBANA_USR=$(KIBANA_USR) \
	KIBANA_PSW=$(KIBANA_PSW) \
	pytest --capture=no \
		--otel-service-name $(OTEL_SERVICE_NAME) \
		--junitxml $(CURDIR)/junit-canary-health-check-with-elastic.xml \
		test_canary_health_check_with_elastic.py

## @help:clean:Remove Python file artifacts.
.PHONY: clean
clean:
	@echo "+ $@"
	@find . -type f -name "*.py[co]" -delete
	@find . -type d -name "__pycache__" -delete
	@find . -name '*~' -delete
	-@rm -fr junit-*.xml $(VENV) .pytest_cache otel-traces-file-output.json
