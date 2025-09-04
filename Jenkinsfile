pipeline {
    agent any
    environment {
        DOCKERHUB_USER = "vineethakondepudi"
        DOCKERHUB_REPO = "trainbook-container"
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
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest"
                }
            }
        }
        stage("Deploy to Swarm") {
    steps {
        // Remove old service if exists
        sh "docker service rm trainbook-container || true"
        
        // Deploy new service
        sh """
          docker service create \
          --name trainbook-container \
          --replicas 3 \
          --publish 8082:80 \
          ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest
        """
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
