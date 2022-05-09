NAME = 'antifraud/build-deploy-antifraud'
DSL = """pipeline {
  agent any
  environment {
    DOCKER_IMAGE_VERSION = "\${params.VERSION}"
    PREVIOUS_VERSION = "\${params.PREVIOUS_VERSION}"
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
    stage('Build') {
      steps {
        build 'antifraud/main'
      }
    }
    stage('Deploy') {
      steps {
        build(job: 'antifraud/deploy-antifraud',
              parameters: [
                string(name: 'PREVIOUS_VERSION', value: env.PREVIOUS_VERSION)
                string(name: 'VERSION', value: env.DOCKER_IMAGE_VERSION)
              ])
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
