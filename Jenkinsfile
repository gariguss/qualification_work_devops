pipeline {
    agent any
 
      environment {
        TF_IN_AUTOMATION = 'true'
  }
    
    stages {
        
        stage ('SSH_remove') {
            steps {
                sh 'rm -f /var/lib/jenkins/id_ed25519'
                sh 'rm -f /var/lib/jenkins/id_ed25519.pub'
            }
        }
        
         stage ('SSH_generate') {
            steps {
                sh 'ssh-keygen -f /var/lib/jenkins/id_ed25519 -P "11111"'
            }
        }
        
        stage('Init') {
            steps {
            sh 'terraform init'
            }
        }
        
        stage('Plan') {
            steps {
            sh 'terraform plan'
            }
        }
       
       stage('Apply') {
            steps {
            sh 'terraform apply -auto-approve'
            }
        }
        
        stage('Inventory') {
            steps {
                sh '/bin/terraform output > hosts' 
                }
        }
        
        stage ('git') {
            steps {
                git 'https://github.com/gariguss/qualification_work_devops.git'
            }
        }
        
        stage ('Destroy') {
            steps {
                sh 'terraform destroy -auto-approve'
            }
        }
    }
}