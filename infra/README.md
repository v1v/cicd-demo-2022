# Demos

This folder contains the required services to Jenkins and interact with different OpenTelemetry vendors.

The demo exposes the following backends:

- Elastic at http://0.0.0.0:5601
- Jenkins at http://0.0.0.0:8080
- Jaeger at http://0.0.0.0:16686

## Context

This is an example of distributed tracing with Jenkins based on:

- [JCasC](https://jenkins.io/projects/jcasc/) to configure a local jenkins instance.
- [JobDSL](https://github.com/jenkinsci/job-dsl-plugin/wiki) to configure the pipelines to test the steps.
- [OpenTelemetry](https://github.com/jenkinsci/job-dsl-plugin/wiki) plugin to send traces :)

## System Requirements

- Docker >= 19.x.x (make sure you have greater than 2gb memory allocated to Docker)
- Docker Compose >= 1.25.0
- Java >= 8
- *nix based (x86_64)

## Run this

1. Build docker image by running:

   ```
   make build
   ```

2. Start the local Jenkins controller service by running:

   ```
   make start-all
   ```

3. Browse to <http://localhost:8080> in your web browser.


## Further details

It uses the OpenTelemetry Collector to send traces and metrics to different vendors, see https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/examples/demo

Originally copied from https://github.com/jenkinsci/opentelemetry-plugin/tree/master/demos
