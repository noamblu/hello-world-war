pipeline {

  }
  stages {
    stage('CheckOut pode') {
      steps {
        git(url: 'https://github.com/noamblu/hello-world-war.git', branch: 'master', credentialsId: 'GitHub')
      }
    }

    stage('Maven package') {
      steps {
        sh '''cd hello-world-war/
mvn clean package'''
      }
    }
    
     stage('Sonarcube verify') {
      steps {
        sh 'mvn verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=noamblu_hello-world-war'
      }
    }

    stage('Archive the artifacts') {
      steps {
        archiveArtifacts(onlyIfSuccessful: true, artifacts: '**/target/*.war')
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
}
