pipeline {
    agent any
    environment {
        DOCKERHUB_USER = "your-dockerhub-username"
        DOCKERHUB_REPO = "trainbook-container"
        SERVICE_NAME = "trainbook-service"
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
                withCredentials([usernamePassword(credentialsId: 'TRS_project', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest"
                }
            }
        }
        stage("Deploy with Docker Swarm") {
            steps {
                script {
                    // Check if the service exists
                    def serviceExists = sh(script: "docker service ls --filter name=${SERVICE_NAME} -q", returnStdout: true).trim()
                    if (serviceExists) {
                        echo "Updating existing Docker Swarm service..."
                        sh "docker service update --image ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest ${SERVICE_NAME}"
                    } else {
                        echo "Creating new Docker Swarm service..."
                        sh "docker service create --name ${SERVICE_NAME} -p 8082:8080 ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest"
                    }
                }
            }
        }
    }
}
