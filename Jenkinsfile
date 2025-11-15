pipeline {
    agent any

    environment {
        // Образ у Docker Hub
        DOCKER_IMAGE   = "maksymonko/frontend"
        REGISTRY_CREDS = "dockerhub-creds"   // ID credential у Jenkins
    }

    options {
        timestamps()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker image') {
            steps {
                sh """
                docker build -t ${DOCKER_IMAGE}:latest .
                """
            }
        }

        stage('Push image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', REGISTRY_CREDS) {
                        sh """
                        docker push ${DOCKER_IMAGE}:latest
                        """
                    }
                }
            }
        }

        stage('Deploy container on server') {
            steps {
                sh """
                docker rm -f frontend-app || true

                docker run -d --name frontend-app \
                  --restart unless-stopped \
                  -p 8081:80 \
                  ${DOCKER_IMAGE}:latest
                """
            }
        }
    }

    post {
        success {
            echo "Deploy successful"
        }
        failure {
            echo "Build/Deploy FAILED"
        }
    }
}
