
resource "aws_instance" "ec2" {
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  subnet_id = aws_subnet.osos-pub.id
  vpc_security_group_ids = [aws_security_group.ansible.id]
  key_name = "new"

 tags = {
    Name = "Bastion"
  }
}

# --------------------------------------"private-ec2"-----------------------------
resource "aws_instance" "Nexus" {
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.medium"
  associate_public_ip_address = false
  subnet_id = aws_subnet.osos-pv1.id
  vpc_security_group_ids = [aws_security_group.ansible.id]
  key_name = "new"

 tags = {
    Name = "Nexus"
  }
}

resource "aws_instance" "Sonarqube" {
  ami           = "ami-0557a15b87f6559cf"
  instance_type = "t2.micro"
  associate_public_ip_address = false
  subnet_id = aws_subnet.osos-pv2.id
  vpc_security_group_ids = [aws_security_group.ansible.id]
  key_name = "new"

 tags = {
    Name = "Sonarqube"
  }
}
