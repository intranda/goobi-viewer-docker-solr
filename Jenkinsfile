pipeline{
  agent any
  stages{
    stage('build images'){
      steps{
        script{
          docker.withRegistry('https://nexus.intranda.com:4443','jenkins-docker'){
            dockerimage = docker.build("goobi-viewer-solr:${env.BUILD_ID}_${env.GIT_COMMIT}")
            dockerimage_public = docker.build("intranda/goobi-viewer-solr:${env.BUILD_ID}_${env.GIT_COMMIT}")
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
            dockerimage.push("${env.BUILD_ID}_${env.GIT_COMMIT}")
            dockerimage.push("latest")
          }
        }
      }
    }
    stage('publish develop image to Docker Hub'){
      agent any
      when {
        branch 'develop'
      }
      steps{
        script{
          docker.withRegistry('','0b13af35-a2fb-41f7-8ec7-01eaddcbe99d'){
            dockerimage_public.push("${env.BRANCH_NAME}")
          }
        }
      }
    }
    stage('publish production image to Docker Hub'){
      agent any
      when {
        branch 'master'
      }
      steps{
        script{
          docker.withRegistry('','0b13af35-a2fb-41f7-8ec7-01eaddcbe99d'){
            dockerimage_public.push("${env.TAG_NAME}")
            dockerimage_public.push("latest")
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
