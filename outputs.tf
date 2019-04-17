output "main_vpc_id" {
  value = "${aws_vpc.main-vpc.id}"
}

output "public_subnet_2a" {
  value = "${aws_subnet.public-subnet-1.id}"
}
output "private_subnet_2a" {
  value = "${aws_subnet.private-subnet-1.id}"
}
output "public_subnet_2b" {
  value = "${aws_subnet.public-subnet-2.id}"
}
output "private_subnet_2b" {
  value = "${aws_subnet.private-subnet-2.id}"
}

output "public_subnet_2c" {
  value = "${aws_subnet.public-subnet-3.id}"
}
output "private_subnet_2c" {
  value = "${aws_subnet.private-subnet-3.id}"
}
output "public_subnet_2d" {
  value = "${aws_subnet.public-subnet-4.id}"
}
output "private_subnet_2d" {
  value = "${aws_subnet.private-subnet-4.id}"
}