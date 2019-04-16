
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region                  = "us-west-2"
  profile                 = "default"
}

resource "aws_vpc" "public-vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "public-vpc"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }

}

resource "aws_internet_gateway" "igw-default" {
  vpc_id = "${aws_vpc.public-vpc.id}"

  tags = {
    Name = "igw-default"
    Owner = "jackson.oliveira"
    Team  = "Dev"
  }

}

# Enables packages be routed to internet on subnets with this route assigned
resource "aws_route_table" "rt-public" {
  vpc_id = "${aws_vpc.public-vpc.id}"

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
  vpc_id     = "${aws_vpc.public-vpc.id}"
  cidr_block = "10.0.0.0/18"
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
  vpc_id     = "${aws_vpc.public-vpc.id}"
  cidr_block = "10.0.64.0/18"
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
  vpc_id     = "${aws_vpc.public-vpc.id}"
  cidr_block = "10.0.128.0/18"
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
  vpc_id     = "${aws_vpc.public-vpc.id}"
  cidr_block = "10.0.192.0/18"
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