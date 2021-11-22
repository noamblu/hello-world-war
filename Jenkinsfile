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
        def dockerImage = docker.build("hello-world-war")
      }
    }

    stage('Docker push') {
      steps {
        script {
          docker.withRegistry('127.0.0.1:5000', 'nexus3-docker-repository') {
            dockerImage.push("$BUILD_NUMBER")
            dockerImage.push("latest")
          }
        }
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
