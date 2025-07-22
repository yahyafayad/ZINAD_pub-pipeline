pipeline {
    agent any

    tools {
        maven 'maven'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']], 
                    credentialsId: 'git_crad', 
                    userRemoteConfigs: [[url: 'https://github.com/yahyafayad/ZINAD_pub-pipeline.git']]
                )
            }
        }

    stage('Build') {
        steps {
            sh 'mvn clean install -DskipTests'
        }
        post {
            success {
                echo 'Now Archiving...'
                archiveArtifacts artifacts: '**/target/*.war'
            }
        }
    }
    

   stage('SonarQube Analysis') {
        steps {
            script {
                withSonarQubeEnv('sonarqube') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=ZINAD_pub-pipeline -Dsonar.host.url=http://localhost:9000'
                }
            }
        }
    }

    stage('Quality Gate') {
        steps {
            timeout(time: 1, unit: 'HOURS') {
                waitForQualityGate abortPipeline: true
            }
        }
    }

    stage('Deploy') {
        steps {
            echo 'Deploying to production...'
            // Add deployment steps here
        }
    }
