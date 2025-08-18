terraform {
  backend "s3" {
    bucket = "newbucket-workspace-12082025"
    key    = "Vansha/terraform.tfstate"
    region = "us-east-1"
  }
}
