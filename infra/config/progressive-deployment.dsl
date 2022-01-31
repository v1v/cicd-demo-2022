NAME = 'progressive-deployment'
DSL = """pipeline {
  agent none
  parameters {
    string(defaultValue: '0.0.1-SNAPSHOT', name: 'PREVIOUS_VERSION')
    string(defaultValue: '0.0.2-SNAPSHOT', name: 'VERSION')
  }
  stages {
    stage('ecommerce-antifraud') {
      steps {
        build 'ecommerce-antifraud/main'
      }
    }
    stage('progressive-deployment') {
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
    stage('smoke-test') {
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
    stage('deployment') {
      steps {
        build(job: 'ansible-production',
              parameters: [string(name: 'DOCKER_IMAGE_VERSION', value: params.VERSION)])
      }
    }
  }
}"""

pipelineJob(NAME) {
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
