pipeline {
  agent any

  stages {

    stage ('Get git repository')
      steps {
                git 'https://github.com/murashovs/final.git'
      }


    stage ('Make EC2 instances')
      steps {
              sh 'terraform init'
              sh 'terraform plan -out=tfplan -input=false'
              sh 'terraform apply -input=false tfplan'
      }

    stage ('Wait for instances preparation')
      steps {
              echo 'Wait 3 minutes'
              sleep 180

      }

    stage ('Build APP from sources, make and pull docker image with web environment')
      steps {
              ansible-playbook buildapp.yml -i hosts ubuntu --private-key /root/.ssh/ser2.pem
      }

    stage ('Deploy WEB container')
      steps {
              ansible-playbook deploy.yml -i hosts ubuntu --private-key /root/.ssh/ser2.pem
      }


    }

  }