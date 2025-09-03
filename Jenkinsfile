pipeline {
    agent any

    options {
        timestamps()   // show time for each log line
        skipDefaultCheckout(true) // we'll checkout explicitly
    }

    environment {
        IMAGE_NAME     = 'todo-app'
        CONTAINER_NAME = 'todo-app'
        APP_PORT       = '8000'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'develop',
                    url: 'https://github.com/MuhammadBurhanShahzad/django-todo-cicd.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:latest .'
            }
        }

        stage('Run Migrations') {
            steps {
                // run a short-lived container just to apply migrations
                sh 'docker run --rm ${IMAGE_NAME}:latest python manage.py migrate'
            }
        }

        stage('Deploy (Run App)') {
            steps {
                // stop & remove old container if exists, then run new one
                sh '''
                  docker rm -f ${CONTAINER_NAME} || true
                  docker run -d --name ${CONTAINER_NAME} -p ${APP_PORT}:8000 ${IMAGE_NAME}:latest
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished. Collecting logs...'
            sh 'docker ps -a || true'
        }
        success {
            echo '✅ Application deployed successfully!'
        }
        failure {
            echo '❌ Build failed. Please check stage logs above.'
        }
    }
}
