NAME = 'ansible-production'
DSL = """pipeline {
  agent any
  stages {
    stage('checkout') {
      steps {
        git(url: 'https://github.com/v1v/demo-fosdem-2022.git', branch: 'v2')
      }
    }
    stage('run-ansible') {
      steps {
      steps {
        withCredentials([usernamePassword(
                        credentialsId: 'docker.io',
                        passwordVariable: 'CONTAINER_REGISTRY_PASSWORD',
                        usernameVariable: 'CONTAINER_REGISTRY_USERNAME')]) {
          dir('ansible-progressive-deployment') {
            sh(label: 'make prepare', script: 'make prepare')
            sh(label: 'run ansible', script: 'make production')
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
