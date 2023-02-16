resource "aws_vpc" "osos-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "osos-vpc"
  }
}
# -----------------------------------------public-sub------------------------------------
resource "aws_subnet" "osos-pub" {
  vpc_id     = aws_vpc.osos-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-sub"
  }
}
resource "aws_subnet" "osos-pub2" {
  vpc_id     = aws_vpc.osos-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-sub2"
  }
}

# -----------------------------------------private-sub------------------------------------
resource "aws_subnet" "osos-pv1" {
  vpc_id     = aws_vpc.osos-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-sub1"
  }
}
resource "aws_subnet" "osos-pv2" {
  vpc_id     = aws_vpc.osos-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-sub2"
  }
}
# -----------------------------------------internet-gw------------------------------------
resource "aws_internet_gateway" "os-gw" {
  vpc_id = aws_vpc.osos-vpc.id

  tags = {
    Name = "ansible-gw"
  }
}

# -----------------------------------------rout-table------------------------------------
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.osos-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.os-gw.id
  }

  tags = {
    Name = "osos-rw"
  }
}
# -----------------------------------------rout-table-association------------------------------------
resource "aws_route_table_association" "pub" {
  subnet_id      = aws_subnet.osos-pub.id
  route_table_id = aws_route_table.example.id
}

resource "aws_route_table_association" "pub2" {
  subnet_id      = aws_subnet.osos-pub2.id
  route_table_id = aws_route_table.example.id
}


# -----------------------------------------nat gw-------------------------------------------------

resource "aws_eip" "example" {
  vpc = true
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.osos-pub.id
}

# -----------------------------------------rout-table-private------------------------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.osos-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name = "osos-rw-private"
  }
}
# -----------------------------------------rout-table-association------------------------------------
resource "aws_route_table_association" "pv1" {
  subnet_id      = aws_subnet.osos-pv1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "pv2" {
  subnet_id      = aws_subnet.osos-pv2.id
  route_table_id = aws_route_table.private.id
}
# --------------------------------------"aws_security_group"-----------------------------
resource "aws_security_group" "ansible" {
  name        = "ansible-sec-group"
  description = "Allow HTTP traffic from anywhere"
  vpc_id = aws_vpc.osos-vpc.id

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
  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress {
    from_port   = 9000
    to_port     = 9000
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