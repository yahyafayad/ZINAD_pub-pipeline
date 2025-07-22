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

        // stage('Quality Gate') {
        //     steps {
        //         timeout(time: 5, unit: 'MINUTES') {
        //             waitForQualityGate abortPipeline: true
        //         }
        //     }
        // }

         stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("zinad-app:${env.BUILD_NUMBER}")
                }
            }
        }
      stage('Scan Docker Image using Trivy') {
        steps {
         script {
            sh """
                trivy image --no-progress --timeout 10m --format table --output trivy-report.txt ${dockerImage.imageName()} || true
            """
        }
        archiveArtifacts artifacts: 'trivy-report.txt', fingerprint: true
    }
}
     stage('DAST Scan with OWASP ZAP') {
         steps {
        sh '''
            # Start OWASP ZAP in background (headless mode)
            zap.sh -daemon -port 8090 -host 127.0.0.1 -config api.disablekey=true &
            echo "Waiting for ZAP to start..."
            sleep 20

            # Run spider on the target
            curl "http://127.0.0.1:8090/JSON/spider/action/scan/?url=http://127.0.0.1:8081&maxChildren=10"
            echo "Spider scan started. Sleeping for 20 seconds..."
            sleep 20

            # Run active scan
            curl "http://127.0.0.1:8090/JSON/ascan/action/scan/?url=http://127.0.0.1:8081"
            echo "Active scan started. Sleeping for 30 seconds..."
            sleep 30

            # Generate HTML report
            curl "http://127.0.0.1:8090/OTHER/core/other/htmlreport/" -o zap-report.html
        '''
        archiveArtifacts artifacts: 'zap-report.html', fingerprint: true
    }
}



        
    }
}
