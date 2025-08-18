provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "abhishek" {
  instance_type = "t2.micro"
  ami = "ami-0de716d6197524dd9" # change this
  subnet_id = "subnet-0afb91067858e0d84" # change this
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "vansha-kher-project-data" # change this
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "vansha-kher-project-data"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}