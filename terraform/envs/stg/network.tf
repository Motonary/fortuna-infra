resource "aws_vpc" "vpc-dev" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags {
    Name = "vpc-dev"
  }
}

resource "aws_subnet" "vpc-dev-public-subnet" {
  vpc_id            = "${aws_vpc.vpc-dev.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags {
    Name = "vpc-dev-public-subnet"
  }
}

resource "aws_internet_gateway" "vpc-dev-igw" {
  vpc_id = "${aws_vpc.vpc-dev.id}"
  tags {
    Name = "vpc-dev-igw"
  }
}

resource "aws_subnet" "vpc-dev-private-subnet" {
  vpc_id            = "${aws_vpc.vpc-dev.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"

  tags {
    Name = "vpc-dev-private-subnet"
  }
}

resource "aws_route_table" "vpc-dev-public-rt" {
  vpc_id = "${aws_vpc.vpc-dev.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.vpc-dev-igw.id}"
  }
  tags {
    Name = "vpc-dev-public-rt"
  }
}

resource "aws_route_table" "vpc-dev-private-rt" {
  vpc_id = "${aws_vpc.vpc-dev.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat.id}"
  }

  tags {
    Name = "vpc-dev-private-rt"
  }
}

resource "aws_route_table_association" "vpc-dev-rta-1" {
  subnet_id      = "${aws_subnet.vpc-dev-public-subnet.id}"
  route_table_id = "${aws_route_table.vpc-dev-public-rt.id}"
}

resource "aws_route_table_association" "vpc-dev-rta-2" {
  subnet_id      = "${aws_subnet.vpc-dev-private-subnet.id}"
  route_table_id = "${aws_route_table.vpc-dev-private-rt.id}"
}



resource "aws_eip" "web-eip" {
  instance = "${aws_instance.dev01.id}"
  vpc      = true
}

resource "aws_eip" "nat" {
  vpc      = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.vpc-dev-public-subnet.id}"
}
