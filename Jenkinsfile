pipeline{
    agent{ label "slave1" }
    options {
        buildDiscarder(logRotator(numToKeepStr: '15'))
    }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('<name credentials>')
    }
    stages{
        stage('Code Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    userRemoteConfigs: [[url: '<url 4pet>']]                    
                ])
            }
        }

        stage('VM1: <Ansiblefile#1>'){
            steps{
                sh '''                 
                cd /<PATH>/final_task/
                ansible-playbook playbook1.yml --vault-password-file ~/.vault_pass.txt
                echo "PRINT Ansible#1>>>"
                '''             
            }
        }        

    }
    
    post {
        always {
            cleanWs()
            sh 'docker logout'            
        }
    }
}
