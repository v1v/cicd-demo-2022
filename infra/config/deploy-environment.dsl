NAME = 'deploy-environment'
DSL = """pipeline {
  agent any
  environment {
    DOCKER_IMAGE_VERSION = "\${params.DOCKER_IMAGE_VERSION}"
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
    stage('Deploy Production') {
      steps {
        withCredentials([usernamePassword(
                        credentialsId: 'docker.io',
                        passwordVariable: 'CONTAINER_REGISTRY_PASSWORD',
                        usernameVariable: 'CONTAINER_REGISTRY_USERNAME')]) {
          dir('ansible-progressive-deployment') {
            sh(label: 'make prepare', script: 'make prepare')
            sh(label: 'run ansible', script: 'make production')
          }
        }
      }
    }
  }
}"""

pipelineJob(NAME) {
  displayName('Deploy whole environment')
  parameters {
    stringParam('DOCKER_IMAGE_VERSION', 'latest', 'Version to be deployed')
  }
  definition {
    cps {
      script(DSL.stripIndent())
    }
  }
}
