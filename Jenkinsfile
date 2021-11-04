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



      }




         }

  }