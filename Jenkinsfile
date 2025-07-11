pipeline {

  agent any

  environment {
    DOCKERHUB_CRED = 'dockerhub-creds-id'
    IMAGE = 'aryanfafo/jenkins-nodejs-app'
    INSTANCE_ID = 'i-007144a114a8151ac'
    REGION = 'ap-south-1'
    CONTAINER = 'jenkins-nodejs-app'
  }

  stages {

    stage('Run Tests') {
      steps {
        script {
          echo 'Running Tests...'
          sh 'npm install'
          sh 'npm test'
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh "docker build -t ${env.IMAGE}:${env.BUILD_NUMBER} ."
          sh "docker tag ${env.IMAGE}:${env.BUILD_NUMBER} ${env.IMAGE}:latest"
        }
      }
    }

    stage('Push to DockerHub') {
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CRED, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
            sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
            sh "docker push ${env.IMAGE}:${env.BUILD_NUMBER}"
            sh "docker push ${env.IMAGE}:latest"
          }
        }
      }
    }

    stage('Deploy to EC2 via SSM') {
      steps {
        script {
          echo 'Deploying Docker container on EC2 using SSM...'
    	  withCredentials([usernamePassword(credentialsId: DOCKERHUB_CRED, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          def deployCommand = "docker pull ${IMAGE}:latest && docker stop ${CONTAINER} || true && docker rm ${CONTAINER} || true && docker run -d --name ${CONTAINER} -p 3000:3000 ${IMAGE}:latest"

            sh """
              aws ssm send-command \
                --document-name "AWS-RunShellScript" \
                --region ${REGION} \
                --instance-ids "${INSTANCE_ID}" \
                --comment "Deploying Docker container via Jenkins pipeline" \
                --parameters 'commands=["${deployCommand}"]' \
                --output text
            """
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
