NAME = 'antifraud-v1/quality-gate'
DSL = """pipeline {
  agent any
  environment {
    HOME = "\${env.WORKSPACE}"
    HOST_TEST_URL = "http://localhost:28080"
    SMOKE_TEST_URL = "\${env.HOST_TEST_URL}/ecommerce"
    KIBANA_URL = "http://localhost:5601"
  }
  stages {
    stage('Checkout') {
      steps {
        git(url: 'https://github.com/v1v/demo-fosdem-2022.git', branch: 'v2')
      }
    }
    stage('Check canary with Elastic') {
      steps {
        sh(label: 'Prepare venv', script: 'make -C python virtualenv')
        sh(label: 'Run Python verification tests', script: 'OTEL_SERVICE_NAME="canary-health-check-with-elastic" make -C python canary-health-check-with-elastic')
      }
    }
  }
}"""

pipelineJob(NAME) {
  displayName('Quality Gate')
  definition {
    cps {
      script(DSL.stripIndent())
    }
  }
}
