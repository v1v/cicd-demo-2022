# Demos

This folder contains the required services to Jenkins and interact with different OpenTelemetry vendors.

The demo exposes the following backends:

- Elastic at http://0.0.0.0:5601
- Jenkins at http://0.0.0.0:8080

## Context

This is an example of distributed tracing with Jenkins based on:

- [JCasC](https://jenkins.io/projects/jcasc/) to configure a local jenkins instance.
- [JobDSL](https://github.com/jenkinsci/job-dsl-plugin/wiki) to configure the pipelines to test the steps.
- [OpenTelemetry](https://github.com/jenkinsci/job-dsl-plugin/wiki) plugin to send traces :)

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

4. Copy nexus credentials

  ```
  docker exec -ti infra_nexus_1 cat nexus-data/admin.password
  ```

5. Browse to http://localhost:8081/#admin/security/users:anonymous and grant `nx-admin` permissions (save)


## Further details

It uses the OpenTelemetry Collector to send traces and metrics to different vendors, see https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/examples/demo

Originally copied from https://github.com/jenkinsci/opentelemetry-plugin/tree/master/demos
