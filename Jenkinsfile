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
                    credentialsId: 'git_cred', 
                    userRemoteConfigs: [[url: 'https://github.com/yahyafayad/ZINAD_pub-pipeline.git']]
                )
        } }}

    stage('Build') {
        steps {
            sh 'mvn clean install -DskipTests'
        }
        post {
            success {
                echo 'Now Archiving...'
                archiveArtifacts artifacts: '**/target/*.war'
        }
    }}}
   stage('SCA - Snyk Scan') {
    steps {
        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
            withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
                sh '''
                    snyk auth $SNYK_TOKEN
                    snyk test --file=pom.xml

                '''
            }
        }
    }
}

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "${SONARQUBE_SCANNER_HOME}/bin/sonar-scanner"
                }
        }
    }
    stage('Quality Gate') {
        steps {
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
        }
    }