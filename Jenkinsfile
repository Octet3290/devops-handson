pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_REGION = 'us-east-1'
        ECR_REPO_URI = '899287366687.dkr.ecr.us-east-1.amazonaws.com/godigital'
        DOCKER_IMAGE_NAME = 'godigital'
        DOCKER_TAG = 'latest'
        TERRAFORM_DIR = './terraform'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_IMAGE_NAME:$DOCKER_TAG .'
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

        stage('Push Docker Image to ECR') {
            steps {
                script {
                    sh 'docker tag $DOCKER_IMAGE_NAME:$DOCKER_TAG $ECR_REPO_URI:$DOCKER_TAG'
                    sh 'docker push $ECR_REPO_URI:$DOCKER_TAG'
                }
            }
        }

        stage('Terraform Init and Apply') {
            steps {
                script {
                    sh 'cd $TERRAFORM_DIR && terraform init && terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy Lambda') {
            steps {
                script {
                    sh 'aws lambda update-function-code --function-name s3_to_rds_lambda --image-uri $ECR_REPO_URI:$DOCKER_TAG'
                }
            }
        }
    }
}
