pipeline {
    agent any

    options {
        timeout(time: 30, unit: 'MINUTES')
        timestamps()
    }

    environment {
        DOCKER_HUB_REPO = 'prathitagarje/basic-webapp'
        DOCKER_HUB_CREDENTIALS = 'dockerhub-credentials'
        GIT_REPO = 'https://github.com/prathitagarje/git-docker-jenkins-project.git'
        IMAGE_TAG = "${BUILD_NUMBER}"
        CONTAINER_NAME = "basic-webapp"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('Build Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_HUB_REPO}:${IMAGE_TAG}")
                    docker.build("${DOCKER_HUB_REPO}:latest")
                }
            }
        }

        stage('Test Container') {
            steps {
                script {
                    sh '''
                    docker run -d --name test-container -p 3001:3000 ${DOCKER_HUB_REPO}:${IMAGE_TAG}
                    
                    # Wait until app is ready
                    for i in {1..10}; do
                      if curl -s http://localhost:3001/health; then
                        echo "App is up!"
                        break
                      fi
                      sleep 3
                    done

                    curl -f http://localhost:3001/api/hello

                    docker stop test-container
                    docker rm test-container
                    '''
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('', "${DOCKER_HUB_CREDENTIALS}") {
                        dockerImage.push("${IMAGE_TAG}")
                        dockerImage.push("latest")
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh '''
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true

                    docker run -d \
                      --name ${CONTAINER_NAME} \
                      -p 3000:3000 \
                      --restart always \
                      ${DOCKER_HUB_REPO}:latest
                    '''
                }
            }
        }

        stage('Health Check') {
            steps {
                script {
                    sh '''
                    for i in {1..10}; do
                      if curl -f http://localhost:3000/health; then
                        echo "Application is healthy!"
                        exit 0
                      fi
                      sleep 3
                    done
                    echo "Health check failed!"
                    exit 1
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning workspace...'
            sh 'docker system prune -f || true'
        }

        success {
            echo 'Deployment successful'
        }

        failure {
            echo 'Pipeline failed'
        }
    }
}