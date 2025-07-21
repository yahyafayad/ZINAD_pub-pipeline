pipeline {
    agent any

    stages{
        stage('Checkout'){
            steps {
                checkout scmGit(
                    branches: [[name: '*/master']], 
                    extensions: [], 
                    userRemoteConfigs: [[url: 'https://github.com/Co0o0oL/vprofile-project/']]
                )
            }
        }
        
        // stage('Build'){
        //     steps {
        //         sh 'mvn clean install -DskipTests'
        //     }
        //     post {
        //         success {
        //             echo 'Now Archiving...'
        //             archiveArtifacts artifacts: '**/target/*.war'
        //         }
        //     }
        // }
        
        stage('Docker Test') {
            agent {
                docker { image 'maven:3.9.10-eclipse-temurin-21-alpine' }
            }
            steps {
                sh 'mvn --version'
            }
        }
        
        // stage ('Publish') {
        //     steps {
        //         nexusPublisher (
        //             nexusInstanceId: 'Nexus_Repo', 
        //             nexusRepositoryId: 'maven-releases', 
        //             packages: [[$class: 'MavenPackage', mavenAssetList: [[classifier: 'vprofile', extension: '', filePath: 'target/vprofile-v1.war']], mavenCoordinate: [artifactId: 'vprofile', groupId: 'vprofile', packaging: 'war', version: '1']]]
        //             )
        //     }
        // }
        
	   // stage('Integration Test'){
    //         steps {
    //             sh 'mvn verify -DskipUnitTests -DskipTests'
    //         }
	   // }
	
	   // stage ('Code Analysis With Checkstyle'){
	   //     steps {
	   //         sh 'mvn checkstyle:checkstyle'
	   //     }
	   //     post {
    //             success {
    //                 echo 'Now Archiving...'
    //                 archiveArtifacts artifacts: '**/target/reports/*.html'
    //                 archiveArtifacts artifacts: '**/target/checkstyle-result.xml'
    //             }
    //         }
	   // }
	    
	   // stage ('SCA'){
	   //     steps {
	   //         nexusPolicyEvaluation (
	   //             advancedProperties: '', enableDebugLogging: true, 
	   //             failBuildOnNetworkError: false, 
	   //             failBuildOnScanningErrors: false, 
	   //             iqApplication: selectedApplication('DSO'), 
	   //             iqInstanceId: 'Sonatype_IQ', 
	   //             iqOrganization: 'c7f2a6a693034795af10cf4c08012230', 
	   //             iqScanPatterns: [[scanPattern: '**/target/*.war']], 
	   //             iqStage: 'build', jobCredentialsId: 'Nexus_IQ',
	   //        )
	   //     }
	   // }
    }
}
