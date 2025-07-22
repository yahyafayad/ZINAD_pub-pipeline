pipeline {
    agent any

    tools {
        maven 'Maven' // لازم تكون معرف maven من Manage Jenkins > Global Tool Config
    }

    environment {
        // هنا ممكن تضيف متغيرات زي JAVA_HOME أو غيره
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/USERNAME/REPO.git'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true
        }
    }
}
