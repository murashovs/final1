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

             sh 'ansible-playbook  -i hosts -K ubuntu -k /var/lib/jenkins/ser2.pem buildapp.yml'
      }
    }
    stage ('Deploy WEB container') {
      steps {
             sh 'ansible-playbook deploy.yml -i hosts --become-user=ubuntu --private-key=/var/lib/jenkins/ser2.pem'
      }
     }
    stage ('Terminate EC2 builder instance ') {
      steps {
             sh 'terraform destroy -target aws_instance.builder'
      }
     }

    }

  }