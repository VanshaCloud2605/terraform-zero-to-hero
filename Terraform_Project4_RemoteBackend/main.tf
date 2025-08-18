provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "webserver" {
  ami = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
  subnet_id = "subnet-0afb91067858e0d84"
}

resource "aws_s3_bucket" "S3_bucket" {
  bucket = "newbucket-workspace-12082025"
}

#Create another S3 bucket and check wthether the State file gets updated or not in S3

resource "aws_s3_bucket" "S3_bucket1" {
  bucket = "newbucket-intellipaat-abc"
}