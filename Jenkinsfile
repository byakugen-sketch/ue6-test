pipeline {
    agent any

    environment {
        IMAGE_NAME = "uzumaki420/ue5-gameserver"
        IMAGE_TAG  = "${BUILD_NUMBER}"
        UE_ROOT    = "/Users/Shared/Epic Games/UE_5.7"
    }

    options {
        timeout(time: 2, unit: 'HOURS')
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'git lfs pull'
            }
        }

        stage('Build Server') {
            steps {
                sh './Scripts/build-server.sh'
            }
        }

        stage('Build Image') {
            steps {
                sh "./Scripts/build-docker.sh ${IMAGE_TAG}"
            }
        }

        stage('Push') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy') {
            steps {
                sh """
                    kubectl set image deployment/ue5-gameserver \
                        gameserver=${IMAGE_NAME}:${IMAGE_TAG}
                    kubectl rollout status deployment/ue5-gameserver --timeout=120s
                """
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'Saved/Logs/*.log', allowEmptyArchive: true
            sh 'rm -rf Output/ docker/LinuxServer/'
        }
        success {
            echo 'Pipeline completed successfully'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
