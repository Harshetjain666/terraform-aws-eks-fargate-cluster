variable "environment" {
    description = "Environment name"
}

variable "vpc_cidr" {
    description = "Cidr value of vpc"
}

variable "vpc_name" {
    description = "Name of vpc"
}   

variable "cluster_name" {
    description = "Name of cluster"
}

variable "public_subnets_cidr" {
    description = "List of public subnet cidr"
}

variable "availability_zones_public" {
    description = "List of availability zones of public subnets"
}

variable "private_subnets_cidr" {
    description = "List of private subnets cidr"
}

variable "availability_zones_private" {
    description = "List of availability zones of private subnets"
}

variable "cidr_block-nat_gw" {
    description = "Destination cidr of nat gateway"
}

variable "cidr_block-internet_gw" {
    description = "Destination cidr of internet gateway"
}