# Create the VPC in which EC2 Instance will be launched
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

# Create a first Public  Subnet.
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.sub1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = "true"
}

# Create an another Public  Subnet.
resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.sub2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = "true"
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

}
# Create a Route Table
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Create a RT Association with two Public Subnets created above
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id
}
# Create Security Group for EC2 instance
resource "aws_security_group" "mysg" {
  name   = "web-sg"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an S3 Bucket
resource "aws_s3_bucket" "name" {
  bucket = "vansha-terraform-demo-08082025"
}
resource "aws_instance" "webserver1" {
  ami                    = var.ami_value1 #Ami value can be same as the instance has been launched from same region and sameAWS account
  instance_type          = var.instance_type1
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id              = aws_subnet.sub1.id
  user_data_base64       = base64encode(file("userdata.sh"))
}

resource "aws_instance" "webserver2" {
  ami                    = var.ami_value1 #Ami value can be same as the instance has been launched from same region and sameAWS account
  instance_type          = var.instance_type1
  vpc_security_group_ids = [aws_security_group.mysg.id]
  subnet_id              = aws_subnet.sub2.id
  user_data_base64       = base64encode(file("userdata1.sh"))
}

#Create Application Load balancer
resource "aws_lb" "myalb" {
  name               = "myalb"
  internal           = false # ie ALB is Public facing
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mysg.id]
  subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]

  tags = {
    Name = "web"
  }
}

#Create a Target Group
resource "aws_lb_target_group" "tg" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id
  health_check {
    path = "/"
    port = "traffic-port"
  }
}

#Attach two Instances to the TG

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}

#Create a Listener Rule

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Fetch the Outputs
output "LoadbalancerDNS" {
  value = aws_lb.myalb.dns_name
}





