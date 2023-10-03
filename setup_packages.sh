#!/bin/bash
# Author: Yashraj Jaiswal
# Description: installation script for important packages
# Updated On: 10/08/2023

function install_docker(){
    echo "Installing docker."
    sudo apt-get update > /dev/null 2>&1
    sudo apt install docker.io > /dev/null 2>&1
    if [ $? -eq 0 ];then
        echo "Docker installation successful."
    else
        echo "Unable to install docker."
    fi
}

function install_docker_compose(){
    echo "Installing Docker compose"
    mkdir -p ~/.docker/cli-plugins/
    curl -SL https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
    chmod +x ~/.docker/cli-plugins/docker-compose
}

function install_jenkins(){
    echo "Installing jenkins"
    apt update
    apt install openjdk-11-jre --yes
    wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key |sudo gpg --dearmor -o /usr/share/keyrings/jenkins.gpg
    sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.gpg] http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
    sudo apt update
    sudo apt install jenkins --yes
    systemctl enable jenkins
    if [ $? -eq 0 ];then
        echo "Jenkins installation successful."
    else
        echo "Unable to install jenkins."
    fi
    # echo "Adding jenkins to the sudo group"
    # sudo echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    echo "Adding jenkins to docker group."
    systemctl stop jenkins
    usermod -aG docker jenkins
    systemctl start jenkins
    echo -n "Jenkins password: "
    cat /var/lib/jenkins/secrets/initialAdminPassword
}

function install_ansible(){
    echo "Installing ansible."
    sudo apt-add-repository ppa:ansible/ansible > /dev/null 2>&1
    sudo apt update > /dev/null 2>&1
    sudo apt install ansible > /dev/null 2>&1
    if [ $? -eq 0 ];then
        echo "Ansible installation successful."
    else
        echo "Unable to install ansible."
    fi
}

function install_node(){
    curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    apt-get install -y nodejs
    npm install -g npm@latest
}

function cleanup(){
    echo "Final: remove ec2setup folder"
    rm -rf /home/ubuntu/ec2setup
}

function display_usage_info(){
    echo "Usage $0 <option-1> <option-2> ..."
    echo "--docker          : Install docker"
    echo "--docker-compose  : Install docker compose"
    echo "--jenkins         : Install jenkins"
    echo "--ansible         : Install ansible"
    echo "--node            : Install node js"
}

main(){
    for option in "$@"; do
        case "$option" in
            "--docker") install_docker ;;
            "--docker-compose") install_docker_compose;;
            "--jenkins") install_jenkins;;
            "--node") install_node;;
            "--ansible") install_ansible;;
            "--help") display_usage_info;;
            *) display_usage_info;;
        esac
    done
    # prompt user for cleanup
    read -p "Do you want to perform a cleanup (y/n) " cleanup
    if [[ "$cleanup" == "y"  ]]; then
        cleanup
    else
        exit 0
    fi
}

main "$@"


