variable "aws_access_key" {
   type = string
   description = "Access Key for AWS"
}

variable "aws_secret_key" {
   type = string
   description = "Secret Key for AWS"
}

variable "aws_region" {
   type = string
   description = "Region for AWS"
   default = "eu-west-2"
}

variable "ec2_ami" {
   type = string
   description = "AMI to use for the ec2 (N.B. changes by region, so if you change the region you will need to change the ami)"
   default  =   "ami-086b3de06dafe36c5"
}

variable "ec2_instance_size" {
   type = string
   description = "Size for the ec2 instance the site will run on"
}

variable "vpc_id" {
   type = string
   description = "ID for the VPC everything will sit in"
}

variable "s3_bucket_name" {
   type = string
   description = "Name for the s3 bucket to store the files (N.B. must be globally unique)"
}