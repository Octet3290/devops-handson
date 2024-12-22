pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')  // ID of your Access Key ID credential
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')  
        AWS_REGION = 'us-east-1'
        ECR_URI = '899287366687.dkr.ecr.us-east-1.amazonaws.com/godigital'
        IMAGE_TAG = 'latest'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/Octet3290/devops-handson.git', branch: 'main'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("godigital:${IMAGE_TAG}")
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                script {
                    // Login to AWS ECR using AWS CLI
                    sh """
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_URI}
                    """
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    // Push the Docker image to ECR
                    sh """
                    docker tag godigital:${IMAGE_TAG} ${ECR_URI}:${IMAGE_TAG}
                    docker push ${ECR_URI}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Apply Terraform to create resources in AWS
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy Lambda') {
            steps {
                script {
                    // Deploy Lambda function with Docker image
                    sh """
                    aws lambda update-function-code --function-name s3_to_rds_lambda \
                        --image-uri ${ECR_URI}:${IMAGE_TAG}
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs() 
        }
    }
}
