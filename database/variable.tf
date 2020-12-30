variable "secret_id" {
    description = "Put your secret name here"
}

variable "identifier" {
    description = "Enter the name of our database which is unique in that region"
}

variable "allocated_storage" {
    description = "Enter the storage of database"
}

variable "storage_type" {
    description = "Put the type of storage you want"
}

variable "engine" {
    description = "Put your database engine you want eg. mysql"
}

variable "engine_version" {
    description = "Which version you want of your db engine"
}

variable "instance_class" {
    description = "Which type of instance you need like ram and cpu  eg. db.t2.micro"
}

variable "database_name" {
    description = "Enter your initial database name"
}

variable "environment" {
    description = "your environment name"
}

variable "private_subnets" {
  description = "List of private subnet IDs"
}

variable "vpc_id" {
  description      =  "put your vpc id"
}