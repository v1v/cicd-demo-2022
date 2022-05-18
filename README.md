# Demo

Progressive deployment with Ansible, Jenkins, Maven, Pytest and Elastic APM specific.

## System Requirements

- Docker >= 19.x.x (make sure you have greater than 2gb memory allocated to Docker)
- Docker Compose >= 1.25.0
- Java >= 11
- *nix based (x86_64)
- Vault for the credentials
- Python3
- Virtualenv (pip3 install virtualenv)

## Configure /etc/hosts

```
127.0.0.1 maven.example.com
127.0.0.1 antifraud-01.example.com antifraud-02.example.com
127.0.0.1 jenkins
127.0.0.1 kibana
127.0.0.1 apm-server
127.0.0.1 otel-collector
```

## Spin up services

```bash
$ make -C infra start-all
```

**NOTE**: The very first time is required to configure Nexus, please read infra/README.md

## Prepare demo

```bash
$ make -C infra demo
```

## Project

https://github.com/v1v/ecommerce-antifraud


## Interact with the jobs

Go to http://localhost:8080/job/antifraud/job/deploy-antifraud/build?delay=0sec

and fill the right versions:

* `0.0.1` is initial version
* `0.0.2` is the version that works out of the box
* `0.0.3` is the version with some regresion.


## List docker containers

```
docker ps --filter 'name=antifraud' --format 'table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Label "org.opencontainers.image.version"}'
```

```
watch docker ps --filter 'name=antifraud'
```
