region      = ""
name        = ""   // Mandatory as used for tagging resources and appended to names.
environment = ""   // Mandatory as used for tagging resources and appended to names. 

# FOR ADDING TAGS ON ALL RESOURCES

additional_tags = {
  key1 = "value1"
  key2 = "value2"
}

# VPC VARIABLES

vpc_cidr               = "172.10.0.0/16"
public_subnets         = ["172.10.1.0/24", "172.10.2.0/24", "172.10.3.0/24"]
private_subnets        = ["172.10.101.0/24", "172.10.102.0/24", "172.10.103.0/24"]
enable_nat_gateway     = true
single_nat_gateway     = true
one_nat_gateway_per_az = false

# BASTION HOST VARIABLES

bastion_host_enabled       = true
bastion_host_instance_type = "t2.micro"