pipeline {
    
    agent {
        label "build-system"
    }
    
    stages {
        stage("Checkout From Git") {
            steps {
                git branch: 'main', url: 'https://github.com/harsh2478/deploy-flaskApp-cicd'
            }
        }
        
        stage("Building Docker Image") {
            steps {
                script {
                    sh "sudo docker build -t kanha05/flask-app:${BUILD_NUMBER} ."
                }
            }
        }
        
        stage("Testing Environnment"){
            steps{
                sh "sudo docker run -dit --name TestingApp-${BUILD_NUMBER} -p ${BUILD_NUMBER}:8080  kanha05/flask-app:${BUILD_NUMBER}"
                retry(30){
                    sh "curl http://54.218.19.182:${BUILD_NUMBER}/ "
                }
            }
        }
        
        stage("Testing"){
            steps{
                retry(30){
                    sh "curl http://54.218.19.182:${BUILD_NUMBER}/ "
                }
            }
        }
        
        stage("Approving"){
            steps{
                script{
                    Boolean userInput = input(id: 'Proceed1', message: 'Ready To Go?', parameters: [[$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Please confirm you agree with this']])
                    echo 'userInput: ' + userInput

                    if(userInput == true){
                        // do action
                    } else {
                        // not do action
                        echo "Action was aborted."
                    }
                }
            }
        }
        
        stage ("Pushing To Dockerhub"){
            steps{
                withCredentials([string(credentialsId: 'DockerHub', variable: 'passwd')]){
                    sh "sudo docker login -u kanha05 -p $passwd "
                    sh "sudo docker push kanha05/flask-app:${BUILD_NUMBER}"
                }
            }
        }
        
        stage("Deploying On Kubernetes"){
            steps{
                sshagent(["IAM_Virginia"]){
                    sh "ssh -o StrictHostKeyChecking=no ec2-user@54.145.74.249 rm -rvf deploy-flaskApp-cicd/ "
                    sh "ssh ec2-user@54.145.74.249 git clone https://github.com/harsh2478/deploy-flaskApp-cicd/"
                    sh "ssh ec2-user@54.145.74.249 sed -i s/replaceImageTag/${BUILD_NUMBER}/g deploy-flaskApp-cicd/deployment.yaml"
                    sh "ssh ec2-user@54.145.74.249 kubectl apply -f deploy-flaskApp-cicd/deployment.yaml"
                    sh "ssh ec2-user@54.145.74.249 kubectl apply -f deploy-flaskApp-cicd/service.yaml"
                }   
            }        
        }
    }
}
