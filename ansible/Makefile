.DEFAULT_GOAL := run

DOCKER_IMAGE?=docker.io/library/demo:0.0.1-SNAPSHOT

.PHONY: prepare
prepare:
	@env ansible-galaxy collection install community.general
	@env pip3 install opentelemetry-api opentelemetry-sdk opentelemetry-exporter-otlp
	@env pip3 install docker

.PHONY: run
run:
	@env ansible-playbook playbook.yml --extra-vars "default_container_image=$(DOCKER_IMAGE)"

.PHONY: run-with-otel
run-with-otel:
	@env \
		OTEL_EXPORTER_OTLP_INSECURE=true \
		OTEL_EXPORTER_OTLP_ENDPOINT=localhost:4317 \
		ansible-playbook playbook.yml --extra-vars "default_container_image=$(DOCKER_IMAGE)"
