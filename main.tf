provider "aws" {
  region = "us-west-2"
}


resource "aws_s3_bucket" "b73" {
    bucket = "dz-7-3-bucket"
    acl = "private"
}

terraform {
  backend "s3" {
    bucket = "dz-7-3-bucket"
    key    = "my/key"
    region = "us-west-2"
  }
}


data "aws_ami" "latest_ubuntu" {
         most_recent = true
         owners      = ["amazon"]

  filter {
      name = "name"
      values = ["*Ubuntu*"]
  }

  filter {
      name = "owner-alias"
      values = ["amazon"]
  }
}

locals {
    web_instance_type_map = {
         stage = "t3.micro"
         prod = "t3.large"
    }
}

locals {
     web_instance_count_map = {
           stage = 1
           prod = 2
     }
}



resource "aws_instance" "web" {
  ami  = data.aws_ami.latest_ubuntu.id
  instance_type = "t3.micro"
  count = 2
  availability_zone = "us-west-2a"
  ebs_optimized=true
  monitoring=true

  tags = {
    Name = "TF_EC2"
  }
}