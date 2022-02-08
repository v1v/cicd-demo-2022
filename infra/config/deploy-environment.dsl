NAME = 'antifraud-v1/deploy-environment'
DSL = """pipeline {
  agent any
  environment {
    DOCKER_IMAGE_VERSION = "\${params.DOCKER_IMAGE_VERSION}"
    CONTAINER_REGISTRY = credentials('docker.io')
  }
  parameters {
    string(defaultValue: 'latest', name: 'DOCKER_IMAGE_VERSION')
  }
  stages {
    stage('Checkout') {
      steps {
        git(url: 'https://github.com/v1v/demo-fosdem-2022.git', branch: 'v2')
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
}"""

pipelineJob(NAME) {
  displayName('Deploy full environment')
  parameters {
    stringParam('DOCKER_IMAGE_VERSION', 'latest', 'Version to be deployed')
  }
  definition {
    cps {
      script(DSL.stripIndent())
    }
  }
}
