pipeline {
    agent any

    environment {
        DOCKER_IMAGE   = "maksymonko/frontend"
        IMAGE_TAG      = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"

        REGISTRY_URL   = ""
        REGISTRY_CREDS = "dockerhub-creds"

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

        stage('Build frontend (npm)') {
            steps {
                sh '''
                npm ci
                npm run build
                '''
            }
        }

        stage('Build Docker image') {
            steps {
                sh """
                docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} .
                docker tag ${DOCKER_IMAGE}:${IMAGE_TAG} ${DOCKER_IMAGE}:latest
                """
            }
        }

        stage('Push image to registry') {
            steps {
                script {
                    if (REGISTRY_URL?.trim()) {
                        docker.withRegistry(REGISTRY_URL, REGISTRY_CREDS) {
                            sh """
                            docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                            docker push ${DOCKER_IMAGE}:latest
                            """
                        }
                    } else {
                        docker.withRegistry('', REGISTRY_CREDS) {
                            sh """
                            docker push ${DOCKER_IMAGE}:${IMAGE_TAG}
                            docker push ${DOCKER_IMAGE}:latest
                            """
                        }
                    }
                }
            }
        }

        stage('Trigger Coolify deploy') {
            steps {
                sh """
                curl -sSf -X POST "${COOLIFY_DEPLOY_HOOK}"
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
