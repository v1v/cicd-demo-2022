NAME = 'java-job'
DSL = """pipeline {
  agent any
  environment {
    HOME = "\${env.WORKSPACE}"
    DOCKERHUB_CREDS = credentials('DockerUserAndToken')
  }
  stages {
    stage('checkout') {
      steps {
        git(url: 'https://github.com/v1v/demo-fosdem-2022.git', branch: 'main')
      }
    }
    stage('compile') {
      steps {
        script {
          dir('java'){
            sh(label: 'Compile Spring Boot hello world', script: './mvnw package')
          }
        }
      }
    }
    stage('build') {
      steps {
        script {
          dir('java'){
            sh(label: 'Build Spring Boot hello world Docker image', script: './mvnw spring-boot:build-image')
            sh(label: 'Docker login', script: 'echo \$DOCKERHUB_CREDS_PSW | docker login docker.io -u \$DOCKERHUB_CREDS_USR --password-stdin')
            sh(label: 'Tag Docker image', script: 'docker tag docker.io/library/demo:0.0.1-SNAPSHOT docker.io/\$DOCKERHUB_CREDS_USR/demo-fosdem:0.0.1-SNAPSHOT')
            sh(label: 'Push Docker image', script: 'docker push docker.io/\$DOCKERHUB_CREDS_USR/demo-fosdem:0.0.1-SNAPSHOT')
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
