pipeline {
  agent any

  environment {
    TF_IN_AUTOMATION = "true"
    TF_INPUT = "0"
    AWS_DEFAULT_REGION = "us-east-1"
  }

  stages {
    stage('Build (terraform fmt)') {
      steps {
        dir('terraform') {
          sh 'terraform fmt -check -recursive'
        }
      }
    }

    stage('Test (terraform validate)') {
      steps {
        dir('terraform') {
          sh 'terraform init -upgrade'
          sh 'terraform validate'
        }
      }
    }

    stage('Deploy (terraform apply)') {
      steps {
        withCredentials([
          [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-creds']
        ]) {
          dir('terraform') {
            sh 'terraform plan -out=tfplan'
            sh 'terraform apply -auto-approve tfplan'
          }
        }
      }
    }

    stage('Smoke test (open site)') {
      steps {
        dir('terraform') {
          script {
            def ip = sh(script: "terraform output -raw public_ip", returnStdout: true).trim()
            echo "EC2 Public IP = ${ip}"

            sh """
              for i in {1..30}; do
                if curl -s --max-time 3 http://${ip} | grep -qi 'hello world i am vinod'; then
                  echo '✅ Website is working'
                  exit 0
                fi
                echo 'Waiting for nginx...'
                sleep 5
              done
              echo '❌ Website not responding'
              exit 1
            """
          }
        }
      }
    }
  }
}
