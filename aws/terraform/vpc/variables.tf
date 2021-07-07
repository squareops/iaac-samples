variable "region" {
  default = "ap-south-1"
  type    = string
}

variable "name" {
  default = ""
  type    = string
}

variable "environment" {
  default = ""
  type    = string
}

variable "additional_tags" {
  description = "Tags for resources "
  type        = map(string)
  default = {
    automation = "true"
  }
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  type    = string
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  type    = list(any)
}

variable "private_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  type    = list(any)
}

variable "enable_nat_gateway" {
  default = false
  type    = bool
}

variable "single_nat_gateway" {
  default = false
  type    = bool
}

variable "one_nat_gateway_per_az" {
  default = false
  type    = bool
}

variable "bastion_host_enabled" {
  default = false
  type    = bool
}

variable "bastion_host_instance_type" {
  default = "t3a.micro"
  type    = string
}

