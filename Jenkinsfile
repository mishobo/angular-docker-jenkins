pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/mishobo/angular-docker-jenkins.git'
            }
        }
        stage('Build') {
            steps {
                script {
                    dockerImage = docker.build("mishobo/angular:${env.BUILD_NUMBER}")
                }
            }
        }
        stage('Test') {
            steps {
                sh 'docker run --rm mishobo/angular:${env.BUILD_NUMBER} ./run-tests.sh'
            }
        }
        stage('Push') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}