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
    stage ('Wait for instances preparation') {
      steps {
              echo 'Wait 2 minutes'
              sleep 120
      }
     }
    stage ('Build APP from sources, make and pull docker image with web environment') {
      steps {

            ansiblePlaybook become: true, colorized: true, credentialsId: 'b966c5be-f66e-4ae4-a58e-9fe403d4ef92', disableHostKeyChecking: true, extras: '-vvv', installation: 'ansible_2.9.13', inventory: 'hosts', limit: 'build', playbook: 'buildapp.yml'
      }
    }
    stage ('Deploy WEB container') {
      steps {
             sh 'ansible-playbook deploy.yml -i hosts'
      }
     }

    }

  }