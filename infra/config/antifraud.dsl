NAME = 'antifraud/antifraud'
multibranchPipelineJob(NAME) {
  branchSources {
    factory {
      workflowBranchProjectFactory {
        scriptPath('Jenkinsfile')
      }
    }
    branchSource {
      source {
        github {
          id('20200109') // IMPORTANT: use a constant and unique identifier
          credentialsId('GitHubUserAndToken')
          repoOwner('v1v')
          repository('ecommerce-antifraud-demo')
          repositoryUrl('https://github.com/v1v/ecommerce-antifraud-demo')
          configuredByUrl(false)
          traits {
            gitHubTagDiscovery()
            gitHubBranchDiscovery {
              strategyId(1)
            }
          }
        }
      }
    }
  }
  orphanedItemStrategy {
    discardOldItems {
      numToKeep(20)
    }
  }
}
