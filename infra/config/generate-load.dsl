NAME = 'generate-load'
DSL = """pipeline {
  agent any
  stages {
    stage('Generate synthetic load') {
      steps {
        sh(script: '''
          for page in {1..20}
          do
            curl -s http://localhost:28080/ecommerce || true
            sleep 1
            curl -s http://localhost:28081/ecommerce || true
            if docker ps | grep -q 'v1v1v/anti-fraud:0.0.2' ; then
              curl -s http://localhost:28080/healthcheck || true
            fi
          done
        ''')
      }
    }
  }
}"""

pipelineJob(NAME) {
  triggers {
    cron('* * * * *')
  }
  definition {
    cps {
      script(DSL.stripIndent())
    }
  }
}
