terraform {
  backend "s3" {
    bucket         = "vansha-kher-project-data" # change this
    key            = "abhi/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock_Vansha"
  }
}
