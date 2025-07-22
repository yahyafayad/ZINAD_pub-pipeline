pipeline {
    agent any

    tools {
        maven 'maven'
    }

    environment {
    SONARQUBE_SCANNER_HOME = tool 'Scanner' 
     }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']], 
                    credentialsId: 'git_cred', 
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

        stage('SCA - Snyk Scan') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
                        sh '''
                            snyk auth $SNYK_TOKEN
                            snyk test || true
                        '''
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh "${SONARQUBE_SCANNER_HOME}/bin/sonar-scanner"
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
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
