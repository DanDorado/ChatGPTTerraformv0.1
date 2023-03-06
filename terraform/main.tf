
provider "aws" {
    region     = var.aws_region
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

terraform {
  backend "http" {
  }
}

resource "aws_instance" "app_instance" {
    ami           = var.ec2_ami
    instance_type = var.ec2_instance_size
    vpc_security_group_ids = [aws_security_group.Open_App_Port.id]

    user_data = <<EOF
#!/bin/bash
pip3 install --upgrade pip
pip3 install openai
pip3 install flask
aws configure set aws_access_key_id {{ example_access_key }} 
aws configure set aws_secret_access_key {{ example_access_secret }}  
aws s3 cp s3://__project_name__-isaunique-buckete-y/__project_name__.zip .
unzip __project_name__.zip
python3 ./app.py
EOF
    tags = {
        Name = "__project_name__"
        Project = "__project_name__"
  }
    depends_on = [
    aws_s3_object.upload_artefact
  ]
}

resource "aws_security_group" "Open_App_Port" {
  name        = "Open_App_Port___project_name__"
  description = "Allow traffic in on port 5000 and out anywhere"
  vpc_id      = var.vpc_id

  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = ["::/0"]
  # }

  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = ["::/0"]
  # }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Open_App_Port___project_name__"
  }
}

resource "aws_s3_bucket" "aibucket" {
  bucket = var.s3_bucket_name

  tags = {
    Name        = var.s3_bucket_name
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "standard_acl" {
  bucket = aws_s3_bucket.aibucket.id
  acl    = "private"
}

# Upload an object
resource "aws_s3_object" "upload_artefact" {
  bucket = aws_s3_bucket.aibucket.id
  key    = "../__project_name__.zip"
  source = "../__project_name__.zip"
}