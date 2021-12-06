pipeline {
  agent {
    node {
      label 'docker-slave'
    }

  }
  stages {
    stage('CheckOut code') {
      steps {
        git(url: 'https://github.com/noamblu/hello-world-war.git', branch: 'dev', credentialsId: 'GitHub')
      }
    }

    stage('Maven package') {
      steps {
        sh 'mvn clean package'
      }
    }

    stage('Sonarcube verify') {
      steps {
        sh 'mvn verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=noamblu_hello-world-war'
      }
    }

    stage('Docker build') {
      steps {
        script {
          dockerImage = docker.build("hello-world-war")
        }
      }
    }

    stage('Docker push') {
      steps {
        script {
          docker.withRegistry('http://127.0.0.1:5000', 'nexus3-docker-repository') {
            dockerImage.push("$BUILD_NUMBER")
            dockerImage.push("latest")
          }
        }

      }
    }

    stage('Remove docker image') {
      steps {
        sh 'docker rmi hello-world-war:$BUILD_NUMBER hello-world-war:$imagename:latest'
        cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true)
      }
    }

  }
   post {
    success {
      slackSend(message: "${env.JOB_NAME} #${env.BUILD_NUMBER} - Started By ${env.BUILD_USER} (${env.BUILD_URL}) finshd successfully", channel: 'noam-dev', color: '#008000')
    }

    failure {
      slackSend(message: "${env.JOB_NAME} #${env.BUILD_NUMBER} - Started By ${env.BUILD_USER} (${env.BUILD_URL}) finshd with error", channel: 'noam-dev', color: '#FF0000')
    }

  }
  environment {
    dockerImage = ''
  }
}
