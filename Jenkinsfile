pipeline {
    agent any
    environment {
        DOCKERHUB_USER = "your-dockerhub-username"
        DOCKERHUB_REPO = "trainbook-app"
        CONTAINER_NAME = "trainbook-container"
    }
    stages {
        stage("Build & Package") {
            steps {
                sh "mvn clean package"
            }
        }
        stage("Build Docker Image") {
            steps {
                sh "docker build -t ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest ."
            }
        }
        stage("Push to Docker Hub") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest"
                }
            }
        }
        stage("Deploy") {
            steps {
                // Stop & remove old container if exists
                sh "docker rm -f ${CONTAINER_NAME} || true"
                // Run new container
                sh "docker run -d --name ${CONTAINER_NAME} -p 8082:8080 ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest"
            }
        }
    }
}

