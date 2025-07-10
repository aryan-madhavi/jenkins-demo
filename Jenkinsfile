pipeline {

  agent any

  environment {
    DOCKERHUB_CRED = 'dockerhub-creds-id'
    IMAGE = 'aryanfafo/jenkins-nodejs-app'
  }

  stages {
      
    stage('Build Docker Image') {
      steps {
        script {
          sh "docker build -t ${env.IMAGE_NAME}:${env.BUILD_NUMBER} ."
          sh "docker tag ${env.IMAGE}:${imageTag} ${env.IMAGE}:latest"
        }
      }
    }

    stage('Push to DockerHub') {
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CRED, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            // sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
            sh "docker push ${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
            sh "docker push ${env.IMAGE_NAME}:latest"
          }
        }
      }
    }
  }

  post {
    always {
      cleanWs()
    }
  }

}
