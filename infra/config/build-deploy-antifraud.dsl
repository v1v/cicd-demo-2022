NAME = 'antifraud/build-deploy-antifraud'
DSL = """pipeline {
  agent any
  environment {
    DOCKER_IMAGE_VERSION = "\${params.VERSION}"
    HOME = "\${env.WORKSPACE}"
    HOST_TEST_URL = "http://localhost:28080"
    SMOKE_TEST_URL = "\${env.HOST_TEST_URL}/ecommerce"
    KIBANA_URL = "http://localhost:5601"
    CONTAINER_REGISTRY = credentials('docker.io')
  }
  parameters {
    string(defaultValue: '0.0.1-SNAPSHOT', name: 'PREVIOUS_VERSION')
    string(defaultValue: '0.0.2-SNAPSHOT', name: 'VERSION')
  }
  stages {
    stage('Checkout') {
      steps {
        git(url: 'https://github.com/v1v/demo-fosdem-2022.git', branch: 'v2')
      }
    }
    stage('Build') {
      steps {
        build 'antifraud/main'
      }
    }
    stage('Deploy Canary') {
      steps {
        dir('ansible-progressive-deployment') {
          sh(label: 'make prepare', script: 'make prepare')
          sh(label: 'run ansible', script: 'make deploy-canary')
        }
      }
      post {
        unsuccessful {
          dir('ansible-progressive-deployment') {
            sh(label: 'make prepare', script: 'make prepare')
            sh(label: 'run ansible', script: "DOCKER_IMAGE_VERSION=\${params.PREVIOUS_VERSION} make rollback")
          }
        }
      }
    }
    stage('Smoke Test') {
      steps {
      }
    }
    stage('Check canary with Elastic') {
      steps {
        sh(label: 'Prepare venv', script: 'make -C python virtualenv')
        sh(label: 'Run Python smoke tests', script: 'OTEL_SERVICE_NAME="smoke-test" make -C python test || true')
        sh(label: 'Run Python verification tests', script: 'OTEL_SERVICE_NAME="canary-health-check-with-elastic" make -C python canary-health-check-with-elastic')
      }
    }
    stage('Deploy full environment') {
      steps {
        dir('ansible-progressive-deployment') {
          sh(label: 'make prepare', script: 'make prepare')
          sh(label: 'run ansible', script: 'make deploy-full-environment')
        }
      }
    }
  }
  post {
    unsuccessful {
      dir('ansible-progressive-deployment') {
        sh(label: 'make prepare', script: 'make prepare')
        sh(label: 'run ansible', script: "DOCKER_IMAGE_VERSION=\${params.PREVIOUS_VERSION} make rollback")
      }
    }
  }
}"""

pipelineJob(NAME) {
  displayName('Build - Deploy AntiFraud')
  parameters {
    stringParam('PREVIOUS_VERSION', '0.0.1-SNAPSHOT', 'Current version')
    stringParam('VERSION', '0.0.2-SNAPSHOT', 'Version to be deployed')
  }
  definition {
    cps {
      script(DSL.stripIndent())
    }
  }
}
