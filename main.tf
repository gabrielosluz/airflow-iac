terraform {
  backend "s3" {
    bucket = "airflow-with-iac-gosl"
    key    = "terraform-test.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  profile = "personal2"
  region  = "us-east-1"
}

# Security Group
resource "aws_security_group" "allow-all-traffic-vpn-ingress" {

  name = "terraform_ingress" 

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks =  ["0.0.0.0/0"]
  }

}

# Security Group
resource "aws_security_group" "allow-all-traffic-vpn-egress" {

  name = "terraform_egress" 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks =  ["0.0.0.0/0"]
  }

}

data "template_file" "init" {
  template = "${file("scripts/startup.sh.tpl")}"
}

resource "aws_instance" "airflow-iac" {
  ami           = "ami-0ed9277fb7eb570c9" # us-west-2
  instance_type = "t3.medium"
  key_name = "airflow-iac2"

  vpc_security_group_ids = [aws_security_group.allow-all-traffic-vpn-ingress.id, aws_security_group.allow-all-traffic-vpn-egress.id] 

  associate_public_ip_address = true

  user_data = "${data.template_file.init.rendered}"

  tags = {
      Name = "Aiflow-Iac"
  } 
}

resource "aws_eip" "public_ip" {
  instance = aws_instance.airflow-iac.id
  vpc      = true
}