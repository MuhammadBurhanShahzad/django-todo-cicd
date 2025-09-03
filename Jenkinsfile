pipeline {
  agent any
  options {
    timestamps()
    ansiColor('xterm')
    skipDefaultCheckout(true)   // we do an explicit checkout stage
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
        // run a short-lived container just to apply DB migrations
        sh 'docker run --rm ${IMAGE_NAME}:latest python manage.py migrate'
      }
    }

    stage('Deploy (Run Container)') {
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
      sh 'docker ps -a | head -n 20 || true'
      sh 'docker logs --tail=100 ${CONTAINER_NAME} || true'
    }
    success { echo '✅ Deployed successfully!' }
    failure { echo '❌ Build failed. Check stage logs above.' }
  }
}
