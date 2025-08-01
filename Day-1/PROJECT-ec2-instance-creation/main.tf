provider "aws" {
    region = "us-east-1"  # Set your desired AWS region
}

resource "aws_instance" "VM_instance" {
    ami           = "ami-020cba7c55df1f615"   # Specify an appropriate AMI ID
    instance_type = "t2.micro"
    subnet_id     = "subnet-0afb91067858e0d84"
    key_name = "18feb_key"
}

