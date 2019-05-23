#!/bin/bash
TAG=$1

sudo cp poc-teste/terraform-files/spring.yml .
sudo sed "s/1/$TAG/g" spring.yml > spring-final.yml
sudo /usr/bin/docker-compose -f /home/ec2-user/spring-final.yml down
sudo /usr/bin/docker-compose -f /home/ec2-user/spring-final.yml build --no-cache
sudo sleep 10
sudo /usr/bin/docker-compose -f /home/ec2-user/spring-final.yml up -d
