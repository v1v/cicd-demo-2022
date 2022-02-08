NAME = 'antifraud-v1/progressive-deployment'
DSL = """pipeline {
  agent none
  parameters {
    string(defaultValue: '0.0.1-SNAPSHOT', name: 'PREVIOUS_VERSION')
    string(defaultValue: '0.0.2-SNAPSHOT', name: 'VERSION')
  }
  stages {
    stage('Build') {
      steps {
        build '../antifraud/main'
      }
    }
    stage('Deploy canary') {
      steps {
        build(job: 'deploy-canary',
              parameters: [string(name: 'DOCKER_IMAGE_VERSION', value: params.VERSION)])
      }
      post {
        unsuccessful {
          build(job: 'rollback',
                parameters: [string(name: 'DOCKER_IMAGE_VERSION', value: params.PREVIOUS_VERSION)])
        }
      }
    }
    stage('Quality Gate') {
      steps {
        build 'quality-gate'
      }
      post {
        unsuccessful {
          build(job: 'rollback',
                parameters: [string(name: 'DOCKER_IMAGE_VERSION', value: params.PREVIOUS_VERSION)])
        }
      }
    }
    stage('Deploy full environment') {
      steps {
        build(job: 'deploy-environment',
              parameters: [string(name: 'DOCKER_IMAGE_VERSION', value: params.VERSION)])
      }
    }
  }
}"""

pipelineJob(NAME) {
  displayName('Build and Deploy AntiFraud')
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
