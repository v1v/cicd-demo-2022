
# Ansible progressive deployment

## Prepare the context

For such, you can run `make prepare` then it will install all the required dependencies in the current context.

## Run the ansible deployment playbook

`make deploy-canary` or if you would like to set what docker image and tag then use `DOCKER_IMAGE=<image:tag> make deploy-canary`.

## Use opentelemetry

```bash
OTEL_EXPORTER_OTLP_INSECURE=true \
OTEL_EXPORTER_OTLP_ENDPOINT=localhost:4317 \
make deploy-canary
```
