provider "aws" {
  region = "ap-southeast-2"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_key_pair" "deployer" {
  key_name   = "ec2-key"
  public_key = file("C:/Users/Priyadharshini/.ssh/id_rsa.pub")
}

resource "aws_security_group" "allow_http" {
  name_prefix = "allow_http"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "docker_app" {
  ami           = "ami-010876b9ddd38475e"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_http.id]

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "EmployeeManagementAutoDeploy"
  }
}

output "instance_public_ip" {
  value = aws_instance.docker_app.public_ip
}
