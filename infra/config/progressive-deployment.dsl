NAME = 'progressive-deployment'
DSL = """pipeline {
  agent none
  stages {
    stage('ecommerce-antifraud') {
      steps {
        build 'ecommerce-antifraud/main'
      }
    }
    stage('progressive-deployment') {
      steps {
        build 'ansible-progressive-deployment'
      }
    }
    stage('smoke-test') {
      steps {
        echo 'TBD'
      }
    }
    stage('deployment') {
      steps {
        build 'ansible-production'
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
