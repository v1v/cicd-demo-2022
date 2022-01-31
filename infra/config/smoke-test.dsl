NAME = 'smoke-test'
DSL = """pipeline {
  agent any
  environment {
    HOME = "\${env.WORKSPACE}"
    HOST_TEST_URL = "http://localhost:28080"
    SMOKE_TEST_URL = "\${env.SMOKE_TEST_URL}/ecommerce"
    KIBANA_URL = "http://localhost:5601"
    OTEL_SERVICE_NAME = "smoke-test"
  }
  stages {
    stage('checkout') {
      steps {
        git(url: 'https://github.com/v1v/demo-fosdem-2022.git', branch: 'v2')
      }
    }
    stage('smoke-test') {
      steps {
        sh(label: 'Prepare venv', script: 'make -C python virtualenv')
        sh(label: 'Run Python smoke tests', script: 'make -C python test')
        sh(label: 'Run Python verification tests', script: 'make -C python test-error-rate')
      }
    }
  }
}"""

pipelineJob(NAME) {
  definition {
    cps {
      script(DSL.stripIndent())
    }
  }
}
