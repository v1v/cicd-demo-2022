NAME = 'progressive-deployment'
DSL = """pipeline {
  agent none
  parameters {
    string(defaultValue: '0.0.1-SNAPSHOT', name: 'PREVIOUS_VERSION')
    string(defaultValue: '0.0.2-SNAPSHOT', name: 'VERSION')
  }
  stages {
    stage('Build') {
      steps {
        build 'ecommerce-antifraud/main'
      }
    }
    stage('Deploy canary') {
      steps {
        build(job: 'ansible-progressive-deployment',
              parameters: [string(name: 'DOCKER_IMAGE_VERSION', value: params.VERSION)])
      }
      post {
        unsuccessful {
          build(job: 'ansible-rollback',
                parameters: [string(name: 'DOCKER_IMAGE_VERSION', value: params.PREVIOUS_VERSION)])
        }
      }
    }
    stage('Quality Gate') {
      steps {
        build 'smoke-test'
      }
      post {
        unsuccessful {
          build(job: 'ansible-rollback',
                parameters: [string(name: 'DOCKER_IMAGE_VERSION', value: params.PREVIOUS_VERSION)])
        }
      }
    }
    stage('Deploy whole environment') {
      steps {
        build(job: 'ansible-production',
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
