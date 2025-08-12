provider "aws" {
  region = "us-east-1"
}

#Create an EC2 Instance
resource "aws_instance" "server" {
    ami = var.ami_value
    instance_type = var.instance_type_value
    subnet_id = var.subnet-id-value
  
}