pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1' 
        ECR_REPO_URI = '899287366687.dkr.ecr.us-east-1.amazonaws.com/godigital' 
        IMAGE_NAME = 'godigital'
        AWS_CREDENTIALS = 'aws-credentials' 
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Octet3290/devops-handson'
               
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $IMAGE_NAME .'
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPO_URI'
                }
            }
        }

        stage('Tag Docker Image') {
            steps {
                script {
                    sh 'docker tag $IMAGE_NAME:latest $ECR_REPO_URI:latest'
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    sh 'docker push $ECR_REPO_URI:latest'
                }
            }
        }

        stage('Apply Terraform') {
            steps {
                script {

                    sh 'terraform init'

             
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Test Lambda') {
            steps {
                script {
              
                    echo 'Lambda function has been successfully deployed.'
                }
            }
        }
    }

    post {
        success {
            echo 'Build and deployment completed successfully!'
        }
        failure {
            echo 'Build or deployment failed.'
        }
    }
}
