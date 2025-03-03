pipeline{
  agent any
  stages{
    stage('build images'){
      steps{
        script{
          docker.withRegistry('https://nexus.intranda.com:4443','jenkins-docker'){
            dockerimage = docker.build("goobi-viewer-docker-solr:${env.BUILD_ID}_${env.GIT_COMMIT}")
            dockerimage_public = docker.build("intranda/goobi-viewer-docker-solr:${env.BUILD_ID}_${env.GIT_COMMIT}")
          }
        }
      }
    }
    stage('publish image to internal repository'){
      steps{
        script {
          docker.withRegistry('https://nexus.intranda.com:4443','jenkins-docker'){
            dockerimage.push("${env.BRANCH_NAME}-${env.BUILD_ID}_${env.GIT_COMMIT}")
            dockerimage.push("${env.BRANCH_NAME}")
          }
        }
      }
    }
    stage('publish production image to internal repository'){
      when {
        branch 'master'
      }
      steps{
        script{
          docker.withRegistry('https://nexus.intranda.com:4443','jenkins-docker'){
            dockerimage.push("latest")
          }
        }
      }
    }
    stage('publish develop image to Docker Hub'){
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
      when {
        branch 'master'
      }
      steps{
        script{
          docker.withRegistry('','0b13af35-a2fb-41f7-8ec7-01eaddcbe99d'){
            dockerimage_public.push("latest")
          }
        }
      }
    }
    stage('publish develop image to GitHub container registry'){
      when {
        branch 'develop'
      }
      steps{
        script{
          docker.withRegistry('https://ghcr.io','jenkins-github-container-registry'){
            dockerimage_public.push("${env.BRANCH_NAME}")
          }
        }
      }
    }
    stage('publish production image to GitHub container registry'){
      when {
        branch 'master'
      }
      steps{
        script{
          docker.withRegistry('https://ghcr.io','jenkins-github-container-registry'){
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
