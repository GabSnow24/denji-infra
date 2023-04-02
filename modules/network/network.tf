resource "aws_vpc" "main_vpc" {
  cidr_block = "172.31.0.0/16"
  tags = {
    "Name"       = var.vpc_data.name
    "Enviroment" = var.environment
    "Resource"   = "Network"
  }
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    "Name"       = "VPC IGW"
    "Enviroment" = var.environment
    "Resource"   = "Network"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = var.availability_zones.first
  cidr_block        = "172.31.0.0/24"
  tags = {
    "Name"       = "PrivateSubnet-1"
    "Resource"   = "Network"
    "Enviroment" = var.environment
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = var.availability_zones.second
  cidr_block        = "172.31.1.0/24"
  tags = {
    "Name"       = "PrivateSubnet-2"
    "Resource"   = "Network"
    "Enviroment" = var.environment
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = var.availability_zones.first
  cidr_block        = "172.31.2.0/24"
  tags = {
    "Name"       = "PublicSubnet-1"
    "Resource"   = "Network"
    "Enviroment" = var.environment
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = var.availability_zones.second
  cidr_block        = "172.31.3.0/24"
  tags = {
    "Name"       = "PublicSubnet-2"
    "Resource"   = "Network"
    "Enviroment" = var.environment
  }
}
resource "aws_route_table" "private-subnet-rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = var.nat_instance_id
  }

  depends_on = [
    var.nat_instance_id,
    aws_vpc.main_vpc
  ]

  tags = {
    "Name"       = "PrivateSubnet-RT"
    "Resource"   = "Network"
    "Enviroment" = var.environment
  }
}

resource "aws_main_route_table_association" "main_subnet" {
  vpc_id         = aws_vpc.main_vpc.id
  route_table_id = aws_route_table.private-subnet-rt.id

  depends_on = [
    var.nat_instance_id,
    aws_route_table.private-subnet-rt
  ]
}

resource "aws_route_table" "public-subnet-rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  depends_on = [
    aws_internet_gateway.vpc_igw,
    aws_vpc.main_vpc
  ]

  tags = {
    "Enviroment" = var.environment,
    "Name"       = "PublicSubnet-RT",
    "Resource"   = "Network"
  }
}

resource "aws_route_table_association" "rt_private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private-subnet-rt.id
}

resource "aws_route_table_association" "rt_private_subnet_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private-subnet-rt.id
}

resource "aws_route_table_association" "rt_public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public-subnet-rt.id
}

resource "aws_route_table_association" "rt_public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public-subnet-rt.id
}




