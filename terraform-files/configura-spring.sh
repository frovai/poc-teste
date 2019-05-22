#!/bin/bash
# Update , instalação do docker e docker-compose, configurar para startar no boot, pull da imagem do Jenkins e permissionamento de usuario
sudo yum update -y
sudo yum install mtr htop telnet sysstat tcpdump docker.x86_64 -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo systemctl start docker.service
sudo systemctl enable docker.service
usermod -aG docker ec2-user

## Configurar EBS - Inicializa o disco EBS, monta um PV, VG e LV do disco com 17G, cria pasta e monta em ext4 o disco, da permissao na pasta para usuario do jenkins, adiciona o caminho montado no FSTAB da máquina e sobe o Jenkins com o arquivo de docker-compose dele.
 
sudo fdisk /dev/xvdf << EE0F
n
p
1


t
8e
w
EE0F
sudo mkdir /home/ec2-user/spring
sudo pvcreate -v /dev/xvdf1
sudo vgcreate spring /dev/xvdf1
sudo lvcreate -L 18G -n springlv spring
sudo mkfs -t ext4 /dev/spring/springlv
sudo mount -t ext4 /dev/spring/springlv /home/ec2-user/spring
sudo chmod 777 /etc/fstab
sudo echo "/dev/spring/springlv   /home/ec2-user/spring    ext4    defaults    0    0" >> /etc/fstab
sudo chmod 644 /etc/fstab
