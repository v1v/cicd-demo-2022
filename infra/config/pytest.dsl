NAME = 'pytest-job'
DSL = """pipeline {
  agent any
  environment {
    HOME = "\${env.WORKSPACE}"
  }
  stages {
    stage('checkout') {
      steps {
        git(url: 'https://github.com/v1v/demo-fosdem-2022.git', branch: 'main')
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
