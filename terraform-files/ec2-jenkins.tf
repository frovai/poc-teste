## Cria uma instancia com nome "jenkins" através do "tags", nos campos "ami", "instance_type" , "subnet_id" , "key_name" , "security_groups" voce pode colocar o ID e nome conforme seu ambiente

resource "aws_instance" "jenkins-instance" {
  ami               = "${var.ami_jenkins}"
  instance_type     = "${var.instance_type_jenkins}"
  availability_zone = "${var.aws_availability_zone}"
  subnet_id         = "${aws_subnet.tools-subnet.id}"
  private_ip        = "${var.jenkins_instance_ip}"
  key_name          = "${var.aws_key_name}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.jenkins-sg.id}"] 
  root_block_device {
        volume_size = 20
      }
  tags {
    Name = "JENKINS"
  }

 connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("${var.aws_key_path}")}"
    agent = true
  }
  provisioner "file" {
    source      = "configura-jenkins.sh"
    destination = "/home/ec2-user/configura-jenkins.sh"
  }
  provisioner "file" {
    source      = "configura-spring.sh"
    destination = "/home/ec2-user/configura-spring.sh"
  }
  provisioner "file" {
    source      = "jenkins.yml"
    destination = "/home/ec2-user/jenkins.yml"
  }
  provisioner "file" {
    source      = "maven.yml"
    destination = "/home/ec2-user/maven.yml"
  }
  provisioner "file" {
    source      = "spring.yml"
    destination = "/home/ec2-user/spring.yml"
  }
  provisioner "file" {
    source      = "keys/felipe-rovai-key.pem"
    destination = "/tmp/felipe-rovai-key.pem"
  }
  provisioner "file" {
    source      = "docker/Dockerfile-jenkins-docker-in-docker"
    destination = "/home/ec2-user/Dockerfile-jenkins-docker-in-docker"
  }
  provisioner "file" {
    source      = "templates/docker.service"
    destination = "/home/ec2-user/docker.service"
  }
}

resource "null_resource" "Configura-Docker" {
  depends_on = ["aws_volume_attachment.jenkins-ebs-att"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file("${var.aws_key_path}")}"
    agent = true
    host = "${element(aws_instance.jenkins-instance.*.public_ip, 0)}"
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 60",
      "sudo chmod +x /home/ec2-user/configura-jenkins.sh",
      "/home/ec2-user/configura-jenkins.sh",
      "sudo chmod 600 /tmp/felipe-rovai-key.pem",
      "sleep 60",
      "scp -i /tmp/felipe-rovai-key.pem -o StrictHostKeyChecking=no /home/ec2-user/configura-spring.sh ec2-user@${var.spring_instance_ip}:/home/ec2-user/configura-spring.sh", ## bootstrap SPRING
      "scp -i /tmp/felipe-rovai-key.pem -o StrictHostKeyChecking=no /home/ec2-user/spring.yml ec2-user@${var.spring_instance_ip}:/home/ec2-user/spring.yml",
      "ssh -o StrictHostKeyChecking=no -i /tmp/felipe-rovai-key.pem ec2-user@${var.spring_instance_ip} 'chmod +x /home/ec2-user/configura-spring.sh'", ## bootstrap SPRING
      "ssh -o StrictHostKeyChecking=no -i /tmp/felipe-rovai-key.pem ec2-user@${var.spring_instance_ip} '/home/ec2-user/configura-spring.sh'", ## bootstrap SPRING
      "scp -i /tmp/felipe-rovai-key.pem -o StrictHostKeyChecking=no /home/ec2-user/spring.yml ec2-user@${var.spring_instance_ip2}:/home/ec2-user/spring.yml",
      "scp -i /tmp/felipe-rovai-key.pem -o StrictHostKeyChecking=no /home/ec2-user/configura-spring.sh ec2-user@${var.spring_instance_ip2}:/home/ec2-user/configura-spring.sh", ## bootstrap SPRING
      "ssh -o StrictHostKeyChecking=no -i /tmp/felipe-rovai-key.pem ec2-user@${var.spring_instance_ip2} 'chmod +x /home/ec2-user/configura-spring.sh'", ## bootstrap SPRING
      "ssh -o StrictHostKeyChecking=no -i /tmp/felipe-rovai-key.pem ec2-user@${var.spring_instance_ip2} '/home/ec2-user/configura-spring.sh'", ## bootstrap SPRING
    ]
  } 
}

resource "aws_volume_attachment" "jenkins-ebs-att" {
  depends_on = ["aws_ebs_volume.jenkins-ebs"]
  device_name = "/dev/xvdf"
  volume_id   = "${aws_ebs_volume.jenkins-ebs.id}"
  instance_id = "${aws_instance.jenkins-instance.id}"
}

resource "aws_ebs_volume" "jenkins-ebs" {
  depends_on = ["aws_instance.jenkins-instance"]
  availability_zone = "${var.aws_availability_zone}"
  size              = 20
  type = "gp2"

  tags {
    Name = "JENKINS EBS"
  }
}
