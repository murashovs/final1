pipeline {
  agent any

  stages {

    stage ('Get git repository') {
      steps {
                git 'https://github.com/murashovs/final.git'
            }
      }

    stage ('Make EC2 instances') {
      steps {
              sh 'terraform init'
              sh 'terraform plan -out myplan'
              sh 'terraform apply -auto-approve myplan'
      }
     }
    stage ('Wait for instances preparations') {
      steps {
              echo 'Wait 3 minutes'
              sleep 180
      }
     }
    stage ('Build APP from sources, make and pull docker image with web environment') {
      steps {

             sh 'ansible-playbook -i hosts buildapp.yml'
      }
    }
    stage ('Deploy WEB container') {
      steps {
             sh 'ansible-playbook -i hosts deploy.yml'
      }
     }

    }

  }