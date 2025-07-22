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
   stage('Push Docker Image') {
    steps {
        script {
            IMAGE_NAME = "zinad-app"
            IMAGE_TAG = "${BUILD_NUMBER}"
            FULL_IMAGE = "yahyafayad/${IMAGE_NAME}:${IMAGE_TAG}"
        }
        withCredentials([usernamePassword(credentialsId: 'dockerhub_cerdintal', usernameVariable: 'yahyafayad', passwordVariable: 'DOCKER_PASS')]) {
            sh '''
                echo "$DOCKER_PASS" | docker login -u "$DOCKyahyafayadER_USER" --password-stdin
                docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${FULL_IMAGE}
                docker push ${FULL_IMAGE}
            '''
        }
    }
}


        stage('Deploy Container') {
            steps {
                sh '''
                    docker rm -f zinad-app-container || true
                    docker run -d --name zinad-app-container -p 8081:8081 ${IMAGE_NAME}:${IMAGE_TAG}
                    sleep 10
                '''
            }
        }


        // stage('Deploy to Kubernetes') {
        //     steps {
        //         script {
        //             sh '''
        //                 kubectl apply -f k8s/deployment.yaml
        //                 kubectl apply -f k8s/service.yaml
        //             '''
        //         }
        //     }
        // }

        // stage('Integration Tests') {
        //     steps {
        //         sh 'mvn verify -DskipTests=false'
        //     }
        // }

        // Uncomment the following stage if you want to include DAST with OWASP ZAP

    //     stage('DAST Scan with OWASP ZAP') {
    //     steps {
    //         script {
    //             echo 'Starting OWASP ZAP container...'
    //             sh '''
    //                 docker rm -f zap-scanner || true
    //
    //                 docker run -u root -d --name zap-scanner -p 8090:8090 ghcr.io/zaproxy/zaproxy \
    //                 zap.sh -daemon -host 0.0.0.0 -port 8090 -config api.disablekey=true
    //
    //                 echo "Waiting for ZAP to be ready..."
    //                 sleep 40
    //
    //                 echo "Starting ZAP Spider scan..."
    //                 curl "http://127.0.0.1:8090/JSON/spider/action/scan/?url=http://172.17.0.1:8081&maxChildren=10"
    //
    //                 echo "Waiting for scan to complete..."
    //                 sleep 30
    //
    //                 echo "Fetching ZAP Report..."
    //                 curl "http://127.0.0.1:8090/OTHER/core/other/jsonreport/" -o zap-report.json || true
    //                 curl "http://127.0.0.1:8090/OTHER/core/other/htmlreport/" -o zap-report.html || true
    //             '''
    //             archiveArtifacts artifacts: 'zap-report.*', allowEmptyArchive: true
    //         }
    //     }
    // }





        
    }
}
