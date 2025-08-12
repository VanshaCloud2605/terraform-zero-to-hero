provider "aws" {
  region = "us-east-1"
}

#Write a module for EC2 instance resource and give the path to Source files (calling the module) and provide variables from terraform.tfvars file here only while calling the module
module "ec2_instance" {
  source  = "./Modules/EC2_instance"
  ami_value = "ami-020cba7c55df1f615"
  instance_type_value = "t2.micro"
  subnet-id-value = "subnet-0afb91067858e0d84"
 
}
