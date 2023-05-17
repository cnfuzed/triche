pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-2'  // Replace with your desired AWS region
        AWS_ACCESS_KEY_ID = credentials('1').accessKeyId  // Replace with the AWS credentials ID configured in Jenkins
        AWS_SECRET_ACCESS_KEY = credentials('1').secretAccessKey  // Replace with the AWS credentials ID configured in Jenkins
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout your Terraform files from version control system (e.g., Git)
                git branch: 'main', url: 'https://github.com/cnfuzed/hello.git'
            }
        }

        stage('Terraform Init') {
            steps {
                // Initialize Terraform in the working directory
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                // Run Terraform plan to preview changes
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply the changes using the previously generated plan
                sh 'terraform apply tfplan'
            }
        }

        stage('Terraform Destroy') {
            steps {
                // Destroy the infrastructure created by Terraform
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}

