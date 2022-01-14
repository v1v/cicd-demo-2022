NAME = 'ansible-job'
DSL = """pipeline {
  agent any
  stages {
    stage('checkout') {
      steps {
        git(url: 'https://github.com/v1v/demo-fosdem-2022.git', branch: 'main')
      }
    }
    stage('run-ansible') {
      steps {
        dir('ansible') {
          sh(label: 'make prepare', script: 'make prepare')
          sh(label: 'run ansible', script: 'make run')
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
