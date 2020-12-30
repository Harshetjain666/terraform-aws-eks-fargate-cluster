variable "cluster_name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "eks_node_group_instance_types" {
  description  = "Instance type of node group"
}


variable "private_subnets" {
  description = "List of private subnet IDs"
}

variable "public_subnets" {
  description = "List of private subnet IDs"
}

variable "fargate_namespace" {
  description = "Name of fargate selector namespace"
}