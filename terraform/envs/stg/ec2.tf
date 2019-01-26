resource "aws_instance" "dev01" {
  ami                    = "ami-426cd343"
  instance_type          = "t2.micro"
  key_name               = "${var.key_name}"
  subnet_id              = "${aws_subnet.vpc-dev-public-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.web-sg.id}"]

  associate_public_ip_address = true
  private_ip                  = "10.0.1.10"

  tags {
    Name = "dev01"
  }
}

resource "aws_instance" "db-replica" {
  ami                    = "ami-426cd343"
  instance_type          = "t2.micro"
  key_name               = "${var.key_name}"
  subnet_id              = "${aws_subnet.vpc-dev-private-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.db-sg.id}"]
  private_ip             = "10.0.2.10"

  tags {
    Name = "db-replica"
  }
}
