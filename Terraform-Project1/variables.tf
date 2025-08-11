#Define the input variables to be used as reference in main.tf file
variable "cidr" {
  description = "Define the CIDR range for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "sub1_cidr" {
  description = "Define the CIDR range for Subnet1"
  type        = string
  default     = "10.0.0.0/24"
}

variable "sub2_cidr" {
  description = "Define the CIDR range for Subnet1"
  type        = string
  default     = "10.0.128.0/17"
}

variable "ami_value1" {
  description = "Define the ami for EC2 instance1"
  type        = string
  default     = "ami-020cba7c55df1f615"
}



variable "instance_type1" {
  description = "Define the instance type for EC2 instance1"
  type        = string
  default     = "t2.micro"
}

