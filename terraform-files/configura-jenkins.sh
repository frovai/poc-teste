#!/bin/bash
# Update , instalação do docker e docker-compose, configurar para startar no boot, pull da imagem do Jenkins e permissionamento de usuario
sudo yum update -y
sudo yum install mtr git htop telnet sysstat tcpdump docker.x86_64 -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo mv /home/ec2-user/docker.service /usr/lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo docker pull jenkins:latest
sudo usermod -aG docker ec2-user

## Configurar EBS - Inicializa o disco EBS, monta um PV, VG e LV do disco com 17G, cria pasta e monta em ext4 o disco, da permissao na pasta para usuario do jenkins, adiciona o caminho montado no FSTAB da máquina e sobe o Jenkins com o arquivo de docker-compose dele.
 
sudo fdisk /dev/xvdf << EE0F
n
p
1


t
8e
w
EE0F
sudo mkdir /home/ec2-user/jenkins
sudo pvcreate -v /dev/xvdf1
sudo vgcreate jenkins /dev/xvdf1
sudo lvcreate -L 18G -n jenkinslv jenkins
sudo mkfs -t ext4 /dev/jenkins/jenkinslv
sudo mount -t ext4 /dev/jenkins/jenkinslv /home/ec2-user/jenkins
sudo chmod 777 /etc/fstab
sudo echo "/dev/jenkins/jenkinslv   /home/ec2-user/jenkins    ext4    defaults    0    0" >> /etc/fstab
sudo chmod 644 /etc/fstab
sudo chmod -R 777 /home/ec2-user/jenkins
sudo /usr/bin/docker-compose -f /home/ec2-user/jenkins.yml build --no-cache
sudo /usr/bin/docker-compose -f /home/ec2-user/jenkins.yml up -d
sudo cd /home/ec2-user/
sudo git clone --branch develop https://github.com/frovai/poc-teste.git
sudo /usr/bin/docker-compose -f /home/ec2-user/maven.yml build --no-cache
