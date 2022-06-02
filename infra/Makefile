.DEFAULT_GOAL := start

VAULT_TOKEN ?= $(shell cat $${HOME}/.vault-token)
VAULT_ADDR  ?= $(shell vault read -field=vault_addr secret/jcasc/localhost/base )
export OTELCOL_IMG?=otel/opentelemetry-collector-contrib-dev:latest
export ELASTIC_STACK_VERSION?=8.1.3

.PHONY: force-build
force-build:
	@env docker-compose --file docker-compose.yml build --no-cache

.PHONY: build
build:
	@env docker-compose --file docker-compose.yml build

.PHONY: demo
demo:
	@env $(MAKE) -C ../ansible-progressive-deployment demo
	@cd rules && ./create-slack-connector.sh

.PHONY: start
start:
	@env \
		VAULT_TOKEN=${VAULT_TOKEN} \
		VAULT_ADDR=${VAULT_ADDR} \
		docker-compose --file docker-compose.yml up --detach

.PHONY: stop
stop:
	@env docker-compose --file docker-compose.yml stop

.PHONY: clean
clean:
	@env docker-compose --file docker-compose.yml down -v

.PHONY: clean-all
clean-all: clean
	@rm -rf ~/.demo-worker || true

.PHONY: start-all  ## Start everything locally
start-all: start start-local-worker

.PHONY: stop-all  ## Stop everything locally
stop-all: stop-local-worker stop

.PHONY: start-local-worker
start-local-worker:  ## Start the local worker
	@echo 'prepare workspace for the worker'
	@mkdir ~/.demo-worker || true
	ln -fs ~/.demo-worker /tmp/worker
	[ ! -e agent.jar ] && wget --quiet -O agent.jar http://localhost:8080/jnlpJars/agent.jar || true
	{ nohup java -jar agent.jar -jnlpUrl http://localhost:8080/computer/local/slave-agent.jnlp > local.log 2>&1 & echo $$! > local.pid; }

.PHONY: stop-local-worker
stop-local-worker:  ## Stop the local worker
	[ -e local.pid ] && ( kill -9 `cat local.pid` ; rm local.pid ) || true
