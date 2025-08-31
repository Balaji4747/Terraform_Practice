resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "this will add a TF generated security group"
  vpc_id      = aws_default_vpc.default.id # reference the default VPC created above interpolation

  # inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Open"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Open"
  }

  ingress {
    to_port     = 8000
    from_port   = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask App"
  }

  # outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All Traffic"
  }

  tags = {
    name = "automate-sg"
  }

}

# Ec2 Instance
resource "aws_instance" "my_instance" {
  for_each = tomap({
    TWS-junoon-automate-1 = "t2.micro"
    TWS-junoon-automate-2 = "t2.micro"
  })

  # meta arguments
  depends_on = [ aws_security_group.my_security_group, aws_key_pair.my_key ]
  key_name        = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id] # reference the security group created above interpolation
  instance_type   = each.value
  ami             = var.ec2_ami_id # Amazon Linux 2 AMI (HVM), SSD Volume Type - us-east-1 ubuntu
  user_data = file("install_nginx.sh")

  root_block_device {

    volume_size = var.env == "prd" ? 20 : var.ec2_default_root_storage_size
    volume_type = "gp3"
  }
  tags = {
    Name = each.key
  }
}

