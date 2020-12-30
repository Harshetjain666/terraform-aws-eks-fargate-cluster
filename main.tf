provider "aws" {
  region = "us-east-1"
  profile = "default"
}

module "vpc" {
    source                              = "./vpc"
    environment                         =  var.environment
    vpc_cidr                            =  var.vpc_cidr
    vpc_name                            =  var.vpc_name
    cluster_name                        =  var.cluster_name
    public_subnets_cidr                 =  var.public_subnets_cidr
    availability_zones_public           =  var.availability_zones_public
    private_subnets_cidr                =  var.private_subnets_cidr
    availability_zones_private          =  var.availability_zones_private
    cidr_block-nat_gw                   =  var.cidr_block-nat_gw
    cidr_block-internet_gw              =  var.cidr_block-internet_gw
}


module "eks" {
    source                              =  "./eks"
    cluster_name                        =  var.cluster_name
    environment                         =  var.environment
    eks_node_group_instance_types       =  var.eks_node_group_instance_types
    private_subnets                     =  module.vpc.aws_subnets_private
    public_subnets                      =  module.vpc.aws_subnets_public
    fargate_namespace                   =  var.fargate_namespace
}


module "kubernetes" {
    source                              =  "./kubernetes"
    cluster_id                          =  module.eks.cluster_id    
    vpc_id                              =  module.vpc.vpc_id
    cluster_name                        =  module.eks.cluster_name
}

module "database" {
    source                              =  "./database"
    secret_id                           =  var.secret_id
    identifier                          =  var.identifier
    allocated_storage                   =  var.allocated_storage
    storage_type                        =  var.storage_type
    engine                              =  var.engine
    engine_version                      =  var.engine_version
    instance_class                      =  var.instance_class
    database_name                       =  var.database_name
    environment                         =  var.environment
    vpc_id                              =  module.vpc.vpc_id
    private_subnets                     =  module.vpc.aws_subnets_private
}