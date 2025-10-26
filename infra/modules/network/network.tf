# Network Resources
#  * VPC
#  * Public & Private Subnets
#  * Internet Gateway
#  * NAT Gateway
#  * Elastic IP
#  * Route Tables & Associations (Public & private)

data "aws_availability_zones" "available" {
	state = "available"
}

# VPC
resource "aws_vpc" "danny_portfolio_vpc" {
	cidr_block           = var.vpc_cidr
	enable_dns_hostnames = true
	enable_dns_support   = true

	tags = merge(var.tags, {
		Name            = "${var.project_name}-vpc"
		expiration_date = var.expiration_date
	})
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
	vpc_id = aws_vpc.danny_portfolio_vpc.id

	tags = merge(var.tags, {
		Name            = "${var.project_name}-igw"
		expiration_date = var.expiration_date
	})
}

# Elastic IP
resource "aws_eip" "nat_eip" {
	domain = "vpc"

	tags = merge(var.tags, {
		Name            = "${var.project_name}-eip"
		expiration_date = var.expiration_date
	})
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
	allocation_id = aws_eip.nat_eip.id
	subnet_id     = aws_subnet.public_subnet[0].id

	tags = merge(var.tags, {
		Name            = "${var.project_name}-ngw"
		expiration_date = var.expiration_date
	})
}

# Public subnets
resource "aws_subnet" "public_subnet" {
	count                   = length(data.aws_availability_zones.available.names)
	vpc_id                  = aws_vpc.danny_portfolio_vpc.id
	cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
	availability_zone       = data.aws_availability_zones.available.names[count.index]
	map_public_ip_on_launch = true

	tags = merge(var.tags, {
		Name                                        = "${var.project_name}-public-${data.aws_availability_zones.available.names[count.index]}"
		expiration_date                             = var.expiration_date
		"KubernetesCluster"                         = var.cluster_name
		"kubernetes.io/role/elb"                    = "1"
		"kubernetes.io/cluster/${var.cluster_name}" = "owned"

	})
}

# Public route table
resource "aws_route_table" "public" {
	vpc_id = aws_vpc.danny_portfolio_vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
	}

	tags = merge(var.tags, {
		Name            = "${var.project_name}-public-table"
		expiration_date = var.expiration_date
	})
}

# Public route table association
resource "aws_route_table_association" "public" {
	count          = length(aws_subnet.public_subnet)
	subnet_id      = aws_subnet.public_subnet[count.index].id
	route_table_id = aws_route_table.public.id
}

# Private Subnets
resource "aws_subnet" "private_subnet" {
	count                   = length(data.aws_availability_zones.available.names)
	vpc_id                  = aws_vpc.danny_portfolio_vpc.id
	cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + length(data.aws_availability_zones.available.names))
	availability_zone       = data.aws_availability_zones.available.names[count.index]
	map_public_ip_on_launch = false

	tags = merge(var.tags, {
		Name                              = "${var.project_name}-private-${data.aws_availability_zones.available.names[count.index]}"
		"kubernetes.io/role/internal-elb" = "1"
	})
}

# Private route table
resource "aws_route_table" "private" {
	vpc_id = aws_vpc.danny_portfolio_vpc.id

	route {
		cidr_block     = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.nat_gateway.id
	}

	tags = merge(var.tags, {
		Name            = "${var.project_name}-private-table"
		expiration_date = var.expiration_date
	})
}

# Private route table association
resource "aws_route_table_association" "private" {
	count          = length(aws_subnet.private_subnet)
	subnet_id      = aws_subnet.private_subnet[count.index].id
	route_table_id = aws_route_table.private.id
}
