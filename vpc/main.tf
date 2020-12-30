
 resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  
  tags = {
    Name = "${var.vpc_name}-${var.environment}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}-${var.environment}" = "shared"
  }
}

resource "aws_subnet" "public" {
  vpc_id                   = aws_vpc.main.id
  cidr_block               = element(var.public_subnets_cidr, count.index)
  availability_zone        = element(var.availability_zones_public, count.index)
  count                    = length(var.public_subnets_cidr)
  map_public_ip_on_launch  = true
  depends_on = [ aws_vpc.main ]
  
  tags = {

      "kubernetes.io/cluster/${var.cluster_name}-${var.environment}" = "shared"
      "kubernetes.io/role/elb" = 1
    Name   = "node-group-subnet-${count.index + 1}-${var.environment}"
    state  = "public"
  }
}



resource "aws_subnet" "private" {
  vpc_id                   = aws_vpc.main.id
  cidr_block               = element(var.private_subnets_cidr, count.index)
  availability_zone        = element(var.availability_zones_private, count.index)
  count                    = length(var.private_subnets_cidr)
  depends_on = [ aws_vpc.main ]
  
  tags = {

        "kubernetes.io/cluster/${var.cluster_name}-${var.environment}" = "shared"
        "kubernetes.io/role/internal-elb" = 1
      "Name"   = "fargate-subnet-${count.index + 1}-${var.environment}"
    "state"  = "private"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  depends_on = [ aws_vpc.main ]

  tags = {
    Name = "eks-internet-gateway-${var.environment}"
  }
}

resource "aws_eip" "nat" {
  vpc              = true
  count = length(var.private_subnets_cidr)
  public_ipv4_pool = "amazon"
}

resource "aws_nat_gateway" "gw" {
  count         = length(var.private_subnets_cidr)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.gw]

  tags = {
    Name = "eks-nat_Gateway-${count.index + 1}-${var.environment}"
  }
}

resource "aws_route_table" "internet-route" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "${var.cidr_block-internet_gw}"
    gateway_id = aws_internet_gateway.gw.id
  }
  depends_on = [ aws_vpc.main ]
  tags  = {
      Name = "eks-public_route_table-${var.environment}"
      state = "public"
  }
}

  resource "aws_route_table" "nat-route" {
  vpc_id = aws_vpc.main.id
  count  = length(var.private_subnets_cidr)
  route {
    cidr_block = "${var.cidr_block-nat_gw}"
    gateway_id = element(aws_nat_gateway.gw.*.id, count.index)
  }
  depends_on = [ aws_vpc.main ]
  tags  = {
      Name = "eks-nat_route_table-${count.index + 1}-${var.environment}"
      state = "public"
  } 
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.internet-route.id
  
  depends_on = [ aws_route_table.internet-route ,
                 aws_subnet.public
  ]
}


resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.nat-route.*.id, count.index)
  depends_on = [ aws_route_table.nat-route ,
                 aws_subnet.private
  ]
}


