pipeline {
    agent any

    tools {
        maven 'Maven' // تأكد إن الاسم هنا مطابق للي معرفه في Jenkins
    }

    environment {
        SONARQUBE_SCANNER_HOME = tool 'DefaultSonarScanner'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('SCA - Snyk Scan') {
            steps {
                withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
                    sh '''
                        snyk auth $SNYK_TOKEN
                        snyk test --severity-threshold=high
                        snyk monitor
                    '''
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
    }
}
