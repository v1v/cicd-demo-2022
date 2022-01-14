NAME = 'cd'
DSL = """pipeline {
  agent none
  stages {
    stage('java') {
      steps {
        build 'java-job'
      }
    }
    stage('ansible') {
      steps {
        build 'ansible-job'
      }
    }
    stage('pytest') {
      steps {
        build 'pytest-job'
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
