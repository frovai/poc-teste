## GLOBAIS:
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_name" {}
variable "aws_key_path" {}
#variable "db_password" {}
variable "aws_region" {
    description = "Region for the VPC"
    default = "us-east-1"
}
variable "aws_availability_zone" {
    description = "Region for the VPC"
    default = "us-east-1a"
}
variable "aws_availability_zone2" {
    description = "Region for the VPC"
    default = "us-east-1b"
}
## RECURSOS VPC
# Nginx

variable "nginx_subnet_cidr" {
  description = "CIDR for the nginx subnet"
  default     = "10.23.1.0/24"
}
# Jenkins
variable "tools_subnet_cidr" {
  description = "CIDR for the Jenkins subnet"
  default     = "10.23.2.0/24"
}
# Spring
variable "spring_subnet_cidr" {
  description = "CIDR for the spring subnet"
  default     = "10.23.3.0/24"
}
## RECURSOS EC2 NGINX

variable "ami_nginx" {
    default = "ami-013be31976ca2c322" ## AMAZON AMI LINUX 2
}

variable "instance_type_nginx" {
    default = "t2.micro"
}

variable "nginx_instance_ip" {
  default = "10.23.1.10"
}

## RECURSOS JENKINS

variable "ami_jenkins" {
    default = "ami-013be31976ca2c322" ## AMAZON AMI LINUX 2
}

variable "instance_type_jenkins" {
    default = "t2.micro"
}

variable "jenkins_instance_ip" {
  default = "10.23.2.10"
}

## RECURSOS SPRING

variable "ami_spring" {
    default = "ami-013be31976ca2c322" ## AMAZON AMI LINUX 2
}

variable "instance_type_spring" {
    default = "t2.micro"
}

variable "spring_instance_ip" {
  default = "10.23.3.10"
}




