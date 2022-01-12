NAME = 'pytest-job'
DSL = """pipeline {
  agent any
  stages {
    stage('checkout') {
      steps {
        git('https://github.com/v1v/demo-fosdem-2022.git')
      }
    }
    stage('smoke-test') {
      steps {
        script {
          docker.image('python:3').inside('--network infra_default') {
            withEnv(["HOME=\${env.WORKSPACE}"]) {
              sh(label: 'Run Python smoke tests', script: 'make -C python test')
            }
          }
        }
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
