module "vpc" {
  source                                          = "terraform-aws-modules/vpc/aws"
  version                                         = "2.77.0"
  name                                            = format("%s-%s-terraform-vpc", var.environment, var.name)
  cidr                                            = var.vpc_cidr # CIDR FOR VPC
  azs                                             = data.aws_availability_zones.available.names
  public_subnets                                  = var.public_subnets  # CIDR FOR PUBLIC SUBNETS
  private_subnets                                 = var.private_subnets # CIDR FOR PRIVATE SUBNETS
  enable_nat_gateway                              = var.enable_nat_gateway
  single_nat_gateway                              = var.single_nat_gateway
  one_nat_gateway_per_az                          = var.one_nat_gateway_per_az
  enable_dns_hostnames                            = true
  enable_vpn_gateway                              = false
  manage_default_network_acl                      = true
  enable_flow_log                                 = true
  create_flow_log_cloudwatch_iam_role             = true
  flow_log_traffic_type                           = "ALL"
  create_flow_log_cloudwatch_log_group            = true
  flow_log_max_aggregation_interval               = 60
  flow_log_destination_type                       = "cloud-watch-logs"
  flow_log_cloudwatch_log_group_retention_in_days = 30



  # TAGS TO BE ASSOCIATED WITH EACH RESOURCE

  tags = tomap(    
    {
      "Name"        = format("%s-%s-terraform-vpc", var.environment, var.name)
      "Environment" = var.environment
    },
  )

  public_subnet_tags = tomap({
    "Name"= "${var.environment}-${var.name}-public-subnet"
  })

  private_subnet_tags = tomap({
    "Name"= "${var.environment}-${var.name}-private-subnet"
  })

  # TAGGING FOR DEFAULT NACL

  default_network_acl_name = format("%s-%s-nacl", var.environment, var.name)
  default_network_acl_tags = {
    "Name"        = format("%s-%s-nacl", var.environment, var.name)
    "Environment" = var.environment
  }
}

