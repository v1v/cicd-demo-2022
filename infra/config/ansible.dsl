NAME = 'my-ansible'
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
        script {
          dir('ansible') {
            // some magic with -u root:root to bypass the due to: 'getpwuid(): uid not found in ansible
            docker.image('geerlingguy/docker-ubuntu2004-ansible').inside('-u root:root --network infra_default') {
              // some magic withEnv to bypass Permission denied: b'/.ansible'
              withEnv(["HOME=\${env.WORKSPACE}"]) {
                sh(label: 'make prepare', script: 'make prepare')
                sh(label: 'run ansible', script: 'make run')
              }
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
