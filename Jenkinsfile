#!/usr/bin/env groovy

pipeline {
    agent {
        docker {
            image 'vivado:2019.2'
        }
    }
    environment {
        DEBIAN_FRONTEND  = 'noninteractive'
        TZ               = 'America/New_York'
    }
    stages {
        stage('Initialize Docker') {
            steps {
                sh 'sudo bash -c "ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone"'
                sh 'sudo apt install -y software-properties-common pkg-config'
                sh 'sudo apt update'
            }
        }
        stage('Prepare') {
            steps {
                sh './prerequisites.sh'
                sh 'git submodule update --init --recursive'
            }
        }
        stage('Build') {
            steps {
                sh 'make init'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing step'
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
