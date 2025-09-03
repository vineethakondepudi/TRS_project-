pipeline {
    agent any
     environment{
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
                sh "docker build -t ${DOCKERHUB_USER}/${DOCKERHUB_REPO} ."
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
        stage("Deploy") {
            steps {
                sh "docker rm -f trainbook-container || true"
                sh "docker run -d --name trainbook-container -p 8082:8080 trainbook-app"
            }
        }
    }
}
