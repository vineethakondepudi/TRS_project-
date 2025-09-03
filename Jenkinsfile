pipeline {
    agent any
    environment {
        DOCKERHUB_USER = "vineethakondepudi"
        DOCKERHUB_REPO = "trainbook_container"
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
        stage("Deploy to Swarm") {
            steps {
                // Remove old service if exists, then deploy a new one
                sh """
                   docker service rm trainbook-service || true
                   docker service create --name trainbook-service \
                     -p 8082:8080 \
                     ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest
                """
            }
        }
    }
}
