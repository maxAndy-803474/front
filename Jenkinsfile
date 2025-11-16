pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "maksymonko/frontend"   // твій репо в Docker Hub
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/maxAndy-803474/front.git'
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
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh """
                    echo "\$DOCKER_PASS" | docker login -u "\$DOCKER_USER" --password-stdin
                    docker push ${DOCKER_IMAGE}:latest
                    docker logout || true
                    """
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
