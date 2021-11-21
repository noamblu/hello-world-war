pipeline {
  agent {
    node {
      label 'docker-slave'
    }

  }
  stages {
    stage('CheckOut pode') {
      steps {
        git(url: 'https://github.com/noamblu/hello-world-war.git', branch: 'dev', credentialsId: 'GitHub')
      }
    }

    stage('debug') {
      steps {
        sh '''pwd
ls -al'''
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
        sh 'docker build -t ${env.JOB_NAME}:${env.BUILD_NUMBER} .'
      }
    }

    stage('Archive the artifacts') {
      steps {
        archiveArtifacts(onlyIfSuccessful: true, artifacts: '**/target/*.war')
        cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true)
      }
    }

  }
  environment {
    SONAR_TOKEN = 'dfe2b88279939d52412bf6588dcc4eb5c77a0a1c'
  }
}