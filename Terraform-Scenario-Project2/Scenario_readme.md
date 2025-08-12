Scenario1: Your team has already created an AWS infrastructure using AWS CFT. 
How to import the configuration from AWS CFT/AWS UI Dashboard as a Terraform script.
Migration from AWS UI/DASHBOARD to TERRAFORM.

This scenario is called "Terraform Migration"

Method1 : As per documentation.

1. Suppose we have an already running AWS EC2 instance on the AWS UI (with Instance ID: i-027cbc68ee8321af3)
2. Write a resource block for the resource you want to import in your configuration. (in main.tf file)
resource "aws_instance" "example" {
  # ...instance configuration...
}

Note : You do not have to complete the body of the resource block. Instead, you can finish defining arguments after the instance is imported.

Run this command in the root folder.
terraform import aws_instance.example i-abcd1234

In our case,
terraform import aws_instance.web-server i-027cbc68ee8321af3
Run the above command.

Then open the terraform.tf state file that has been generated containing all the details of the EC2 instance.

Copy the AMI, Instance type, subnet -id and other parameters required in your main.tf file.

Delete the EC2 instance created from AWS UI and run Terraform apply to create an EC2 instance via this new imported Terraform script.
***************************************************************************************************

Method2:
Again create a new EC2 instance from UI/Dashboard with Instance Id as : i-05872d148a110b8bc
Create a main.tf file ( the previous main.tf file I am oevrwriting for this demo).
Give the provider info in main.tf file.
provider "aws" {
    region = "us-east-1"
  
}

import {
  id = "i-05872d148a110b8bc"
to = aws_instance.web-server
}
Use this command : (after terraform init on the root folder)
terraform plan -generate-config-out=generatedresources.tf

Run this command and a new file "generatedresources.tf" will be generated.
It contains all the attributes of already existing EC2 instance.
Now copy paste the contents of this generatedresources.tf file and delete it along with import statements in main.tf file.

Run Terraform plan :  It says 1 to add (because it doesnot know that the resource EC2 isntance is already present/created in the AWS UI). To create the state file : use command:

terraform import aws_instance.web-server i-05872d148a110b8bc

Import has been successful.!
With this command, Statefile has been generated.

Now if we do terraform plan,

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

If we do terrafom apply, it will say : 

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so
no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed

The resource is already present in AWS UI.

************************************************************************************
