##########################
# Network infrastructure #
##########################

resource "aws_vpc" "main" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

#########################################################
# Internet Gateway needed for inbound access to the ALB #
#########################################################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.prefix}-main"
  }
}

##################################################
# Public subnets for load balancer public access #
##################################################

# Declare AZs available data source
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  # availability_zone       = "${data.aws_region.current.name}a"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    # Name = "${local.prefix}-public-a"
    Name = "${local.prefix}-${data.aws_availability_zones.available.names[0]}"
  }
}

resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.main.id

  tags = {
    # Name = "${local.prefix}-public-a"
    Name = "${local.prefix}-${data.aws_availability_zones.available.names[0]}"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_a.id
}

resource "aws_route" "public_internet_access_a" {
  route_table_id         = aws_route_table.public_a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = true
  # availability_zone       = "${data.aws_region.current.name}b"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    # Name = "${local.prefix}-public-b"
    Name = "${local.prefix}-${data.aws_availability_zones.available.names[1]}"
  }
}

resource "aws_route_table" "public_b" {
  vpc_id = aws_vpc.main.id

  tags = {
    # Name = "${local.prefix}-public-b"
    Name = "${local.prefix}-${data.aws_availability_zones.available.names[1]}"
  }
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_b.id
}

resource "aws_route" "public_internet_access_b" {
  route_table_id         = aws_route_table.public_b.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}
