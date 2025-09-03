pipeline {
    agent any
    environment {
        DOCKERHUB_USER = "your-dockerhub-username"
        DOCKERHUB_REPO = "trainbook-app"
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
                sh "docker rm -f trainbook-container || true"
                sh "docker run -d --name trainbook-container -p 8082:8080 ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest"
            }
        }
    }
}

