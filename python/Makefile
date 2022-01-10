# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0

OTEL_EXPORTER_OTLP_ENDPOINT ?= http://127.0.0.1:4317
OTEL_SERVICE_NAME ?= "pytest_otel_test"
OTEL_EXPORTER_OTLP_INSECURE ?= True
OTEL_EXPORTER_OTLP_HEADERS ?=
TRACEPARENT ?=

HELLO_WORLD_URL ?= http://localhost:8080/hello
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

## @help:test:Run the test.
.PHONY: test
test: virtualenv
	source $(VENV)/bin/activate;\
	HELLO_WORLD_URL=$(HELLO_WORLD_URL) \
	pytest --capture=no \
		--junitxml $(CURDIR)/junit-smoke-tests.xml \
		test_smoke.py;

## @help:clean:Remove Python file artifacts.
.PHONY: clean
clean:
	@echo "+ $@"
	@find . -type f -name "*.py[co]" -delete
	@find . -type d -name "__pycache__" -delete
	@find . -name '*~' -delete
	-@rm -fr junit-*.xml $(VENV) .pytest_cache otel-traces-file-output.json
	
