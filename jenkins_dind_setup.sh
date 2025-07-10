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

echo "[INFO] Installing Docker CLI in Jenkins container..."
docker exec -u root jenkins-dind bash -c \
  "apt-get update && apt-get install -y docker.io"

echo "[INFO] Jenkins is running on http://localhost:8080"
echo "[INFO] Admin password: "
docker exec jenkins-dind cat /var/jenkins_home/secrets/initialAdminPassword
