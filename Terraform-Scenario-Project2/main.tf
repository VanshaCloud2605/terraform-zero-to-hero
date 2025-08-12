provider "aws" {
    region = "us-east-1"
  
}

resource "aws_instance" "web-server" {
  ami                                  = "ami-020cba7c55df1f615"
  instance_type                        = "t2.micro"
  subnet_id                            = "subnet-0afb91067858e0d84"
  }




