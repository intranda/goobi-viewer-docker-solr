pipeline{
  agent any
  stages{
    stage('build images'){
      steps{
        script{
          docker.withRegistry('https://nexus.intranda.com:4443','jenkins-docker'){
            image = docker.build("goobi-viewer-solr:${env.BUILD_ID}_${env.GIT_COMMIT}")
          }
        }
      }
    }
    stage('publish images'){
      when {
        branch 'master'
      }
      steps{
        script{
          docker.withRegistry('https://nexus.intranda.com:4443','jenkins-docker'){
            image.push("${env.BUILD_ID}_${env.GIT_COMMIT}")
            image.push("latest")
          }
        }
      }
    }
  }
  post {
    always{
      deleteDir()
    }
    changed {
      emailext(
        subject: '${DEFAULT_SUBJECT}',
        body: '${DEFAULT_CONTENT}',
        recipientProviders: [requestor(),culprits()],
        attachLog: true
      )
    }
  }
}
