NAME = 'smoke-test'
DSL = """pipeline {
  agent any
  environment {
    HOME = "\${env.WORKSPACE}"
    SMOKE_TEST_URL = "http://localhost:28080/ecommerce"
  }
  stages {
    stage('checkout') {
      steps {
        git(url: 'https://github.com/v1v/demo-fosdem-2022.git', branch: 'v2')
      }
    }
    stage('smoke-test') {
      steps {
        sh(label: 'Run Python smoke tests', script: 'make -C python test')
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
