#!/usr/bin/env bash

echo "[INFO] Starting Jenkins container with Docker socket access..."
docker run -d \
  --name jenkins-dind \
  -u root \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts

echo "[INFO] Installing Docker CLI, curl, unzip, Node.js 21, npm in Jenkins container..."
docker exec -u root jenkins-dind bash -c "
  apt-get update && \
  apt-get install -y docker.io curl unzip && \
  curl -fsSL https://deb.nodesource.com/setup_21.x | bash - && \
  apt-get install -y nodejs
"

echo "[INFO] Installing AWS CLI v2 in Jenkins container..."
docker exec -u root jenkins-dind bash -c "
  curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip' && \
  unzip awscliv2.zip && \
  ./aws/install && \
  rm -rf aws awscliv2.zip
"

echo "[INFO] Jenkins is running on http://localhost:8080"
echo "[INFO] Admin password:"
docker exec jenkins-dind cat /var/jenkins_home/secrets/initialAdminPassword
