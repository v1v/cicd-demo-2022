NAME = 'java-job'
DSL = """pipeline {
  agent any
  stages {
    stage('checkout') {
      steps {
        git('https://github.com/v1v/demo-fosdem-2022.git')
      }
    }
    stage('compile') {
      steps {
        script {
          docker.image('openjdk:8-jdk-alpine').inside('--network infra_default') {
            withEnv(["HOME=\${env.WORKSPACE}"]) {
              dir('java'){
                sh(label: 'Compile Spring Boot hello world', script: './mvnw package')
              }
            }
          }
        }
      }
    }
    stage('build') {
      steps {
        script {
          docker.image('openjdk:8-jdk-alpine').inside('--network infra_default') {
            withEnv(["HOME=\${env.WORKSPACE}"]) {
              dir('java'){
                sh(label: 'Build Spring Boot hello world Docker image', script: './mvnw spring-boot:build-image')
              }
            }
          }
          sh(label: 'Docker login', script: 'echo $GITHUB_USERNAME | docker login ghcr.io -u $GITHUB_USERNAME --password-stdin')
          sh(label: 'Tag Docker image', script: 'docker tag docker.io/library/demo:0.0.1-SNAPSHOT ghcr.io/$GITHUB_USERNAME/demo:0.0.1-SNAPSHOT')
          sh(label: 'Push Docker image', script: 'docker push ghcr.io/$GITHUB_USERNAME/demo:0.0.1-SNAPSHOT')
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
