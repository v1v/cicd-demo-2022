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
            sleep .$[ ( $RANDOM % 13 ) + 1 ]s
            curl -s http://localhost:28080/ecommerce || true
          done
        ''')
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
