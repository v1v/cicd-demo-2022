# Demo

Progressive deployment with Ansible, Jenkins, Maven, Pytest and Elastic APM specific.

## Prepare demo

```bash
$ make -C infra demo
```

## Configure /etc/hosts

```
127.0.0.1 maven.example.com
127.0.0.1 jenkins
127.0.0.1 kibana
127.0.0.1 jaeger
127.0.0.1 apm-server
127.0.0.1 otel-collector
```

## Spin up services

```bash
$ make -C infra start-all
```

## Interact with the jobs

Go to http://localhost:8080/job/progressive-deployment/

and fill the right versions:

* `0.0.1-SNAPSHOT` is initial version
* `0.0.2-SNAPSHOT` is the version that works out of the box
* `0.0.3-SNAPSHOT` is the version with some regresion.

