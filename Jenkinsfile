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
        sh 'docker build -t 127.0.0.1:500/hello-world-war:$BUILD_NUMBER .'
      }
    }

    stage('Docker push') {
      steps {
        sh 'docker push 127.0.0.1:500/hello-world-war:$BUILD_NUMBER'
      }
    }

    stage('Archive the artifacts') {
      steps {
        archiveArtifacts(onlyIfSuccessful: true, artifacts: '**/target/*.war')
        cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true)
      }
    }

  }
}