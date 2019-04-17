
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region                  = "us-west-2"
  profile                 = "default"
}

resource "aws_vpc" "main-vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }

}

resource "aws_internet_gateway" "igw-default" {
  vpc_id = "${aws_vpc.main-vpc.id}"

  tags = {
    Name = "igw-default"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }
}

# Enables packages be routed to internet on subnets with this route assigned
resource "aws_route_table" "rt-public" {
  vpc_id = "${aws_vpc.main-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw-default.id}"
  }

  tags = {
    Name = "rt-public"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }

}

resource "aws_subnet" "public-subnet-1" {
  vpc_id     = "${aws_vpc.main-vpc.id}"
  cidr_block = "10.0.0.0/19"
  map_public_ip_on_launch = true
  availability_zone =  "us-west-2a"

  tags = {
    Name = "public-subnet-1"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }
}

resource "aws_route_table_association" "rt-association-subnet-1" {
  subnet_id      = "${aws_subnet.public-subnet-1.id}"
  route_table_id = "${aws_route_table.rt-public.id}"
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = "${aws_vpc.main-vpc.id}"
  cidr_block = "10.0.32.0/19"
  availability_zone =  "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }

}

resource "aws_route_table_association" "rt-association-subnet-2" {
  subnet_id      = "${aws_subnet.public-subnet-2.id}"
  route_table_id = "${aws_route_table.rt-public.id}"
}

resource "aws_subnet" "public-subnet-3" {
  vpc_id     = "${aws_vpc.main-vpc.id}"
  cidr_block = "10.0.64.0/19"
  availability_zone =  "us-west-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-3"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }
}

resource "aws_route_table_association" "rt-association-subnet-3" {
  subnet_id      = "${aws_subnet.public-subnet-3.id}"
  route_table_id = "${aws_route_table.rt-public.id}"
}

resource "aws_subnet" "public-subnet-4" {
  vpc_id     = "${aws_vpc.main-vpc.id}"
  cidr_block = "10.0.96.0/19"
  map_public_ip_on_launch = true
  availability_zone =  "us-west-2d"

  tags = {
    Name = "public-subnet-4"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }

}
resource "aws_route_table_association" "rt-association-subnet-4" {
  subnet_id      = "${aws_subnet.public-subnet-4.id}"
  route_table_id = "${aws_route_table.rt-public.id}"
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = "${aws_vpc.main-vpc.id}"
  cidr_block = "10.0.128.0/19"
  map_public_ip_on_launch = false
  availability_zone =  "us-west-2a"

  tags = {
    Name = "private-subnet-1"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = "${aws_vpc.main-vpc.id}"
  cidr_block = "10.0.160.0/19"
  map_public_ip_on_launch = false
  availability_zone =  "us-west-2b"

  tags = {
    Name = "private-subnet-2"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }
}

resource "aws_subnet" "private-subnet-3" {
  vpc_id     = "${aws_vpc.main-vpc.id}"
  cidr_block = "10.0.192.0/19"
  map_public_ip_on_launch = false
  availability_zone =  "us-west-2c"

  tags = {
    Name = "private-subnet-3"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }
}

resource "aws_subnet" "private-subnet-4" {
  vpc_id     = "${aws_vpc.main-vpc.id}"
  cidr_block = "10.0.224.0/19"
  map_public_ip_on_launch = false
  availability_zone =  "us-west-2d"

  tags = {
    Name = "private-subnet-4"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }
}

resource "aws_security_group" "sg_public" {
  name        = "sg_public"
  description = "That should allow SSH connections from internet"
  vpc_id      = "${aws_vpc.main-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_public_cidr}"]
    description = "Your personal IP addresss"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  
}

resource "aws_security_group" "sg_private" {
  name        = "sg_private"
  vpc_id      = "${aws_vpc.main-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_public_cidr}"]
    description = "Your personal IP addresss"
  }

  # That wont work. Instances will assigned to this SG wont be internet facing
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.sg_public.id}"]
    description = "Firewall rule allowing connections from the internet facing instance"
  }

  # That wont work. Instances assigned to this SG wont have external access
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "public-instance" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.sg_public.id}"]
  key_name = "${var.key_pair}"
  subnet_id = "${aws_subnet.public-subnet-1.id}"

  tags = {
    Name = "public-instance"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }
}

resource "aws_instance" "private-instance" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.sg_private.id}"]
  key_name = "${var.key_pair}"
  subnet_id = "${aws_subnet.private-subnet-1.id}"

  tags = {
    Name = "private-instance"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }
}