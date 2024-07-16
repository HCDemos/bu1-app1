provider "aws" {
  region = "us-east-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

#test
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  count         = 1
  tags = {
    name = "${var.prefix}-vpc-${var.region}"
    owner = var.prefix
    region = var.hashi-region
    purpose = var.purpose
    ttl = var.ttl
    Department = var.Department
    Billable = var.Billable
  }
}

check "aws_instances_stopped" {
  data "aws_instances" "web" {
    instance_state_names = "stopped"
  }
  assert {
    condition     = length(data.aws_instances.web) > 0
    error_message = format("Found Instances have stopped! Instance ID’s: %s", data.aws_instances.web.ids)
  }
}
