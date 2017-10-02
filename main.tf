#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-d651b8ac
#
# Your subnet ID is:
#
#     subnet-9d9493c7
#
# Your security group ID is:
#
#     sg-2788a154
#
# Your Identity is:
#
#     NWI-vault-lizard
#

terraform {
   backend "atlas" {
	name = "usleiwang/training"
   }
}

module "example" {
   source = "./example-module"
   command = "echo Goodbye World"
}

variable "aws_webs" {
   default = "2"
}

variable "aws_access_key" {
    type = "string"
}

variable "aws_secret_key" {
    type = "string"
}

variable "aws_region" {
    type = "string"
    default = "us-east-1"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  # ...
  count                  = "3"
  ami                    = "ami-d651b8ac"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-9d9493c7"
  vpc_security_group_ids = ["sg-2788a154"]

  tags {
    Name = "web ${count.index+1}/${var.aws_webs}"
    "Identity" = "NWI-vault-lizard"
    "Poo" = "bar"
    "Zip" = "zap"
  }
}

output "public_ip" {
   value = ["${aws_instance.web.*.public_ip}"]
}

output "public_dns" {
   value = ["${aws_instance.web.*.public_dns}"]
}


