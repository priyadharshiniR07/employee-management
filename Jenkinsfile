pipeline {
    agent any

    environment {
        IMAGE_NAME = 'priyadharshiniro7/employee-management'
        AWS_REGION = 'ap-southeast-2'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/priyadharshiniR07/employee-management.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %IMAGE_NAME% ."
            }
        }

        stage('Login to Docker Hub & Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat "docker login -u %DOCKER_USER% -p %DOCKER_PASS%"
                    bat "docker push %IMAGE_NAME%"
                }
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                withAWS(credentials: 'aws-creds', region: "${env.AWS_REGION}") {
                    dir('terraform') {
                        bat "terraform init"
                        bat "terraform apply -auto-approve"
                    }
                }
            }
        }

        stage('Deployment Complete') {
            steps {
                script {
                    def ec2_ip = bat(script: "cd terraform && terraform output -raw instance_public_ip", returnStdout: true).trim()
                    echo "🚀 Employee Management App running at: http://${ec2_ip}:8000"
                }
            }
        }
    }
}
