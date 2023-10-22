pipeline {
  agent any
  stages {

    stage('Clone repository') {
      when {
        expression {
          BRANCH_NAME == 'master'
        }
      }
      steps {
        checkout scm
      }
    }

    stage('Build Image') {
      when {
        expression {
          BRANCH_NAME == 'master'
        }
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerHub', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
          sh 'docker build --no-cache -t $DOCKERHUB_USERNAME/migrate:latest -f Dockerfile .'
        }
      }
    }

    stage('Push Image') {
      when {
        expression {
          BRANCH_NAME == 'master'
        }
      }
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
          sh 'docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD'
          sh 'docker image push --all-tags $DOCKERHUB_USERNAME/migrate'
        }
      }
    }
  }
  post {
    always {
      sh 'docker system prune -a -f'
      sh 'docker logout'
    }
  }
}