data "aws_caller_identity" "current" {}

resource "tls_private_key" "bastion" {
  count     = var.bastion_host_enabled ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "bastion_private_key" {
  content         = tls_private_key.bastion.0.private_key_pem
  filename        = "./bastion_private_keypair.pem"
  file_permission = "0600"
}

module "bastion_key_pair" {
  count      = var.bastion_host_enabled ? 1 : 0
  source     = "terraform-aws-modules/key-pair/aws"
  version    = "0.6.0"
  key_name   = format("%s-%s-%s", var.environment, var.name, "bastion-key-pair")
  public_key = tls_private_key.bastion.0.public_key_openssh
}

resource "aws_eip" "bastion" {
  count    = var.bastion_host_enabled ? 1 : 0
  vpc      = true
  instance = module.bastion_host.0.id[0]
}

module "security_group_bastion" {
  count       = var.bastion_host_enabled ? 1 : 0
  source      = "terraform-aws-modules/security-group/aws"
  version     = "~> 4"
  create      = true
  name        = format("%s-%s-%s", var.environment, var.name, "bastion-sg")
  description = "bastion server security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Public SSH access"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = tomap(
    {
      "Name"        = format("%s-%s-%s", var.environment, var.name, "bastion-sg")
      "Environment" = var.environment
    },
  )
}

data "aws_ami" "ubuntu_18_ami" {
  count       = var.bastion_host_enabled ? 1 : 0
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  user_data = <<EOF
#!/bin/bash
echo "bootstrapping Cpmmands for Bastion Server Can bee inserted here"
EOF
}

module "bastion_host" {
  count                       = var.bastion_host_enabled ? 1 : 0
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "2.17.0"
  name                        = format("%s-%s-%s", var.environment, var.name, "bastion-ec2-instance")
  instance_count              = 1
  ami                         = data.aws_ami.ubuntu_18_ami.0.image_id
  instance_type               = var.bastion_host_instance_type
  subnet_ids                  = module.vpc.public_subnets
  key_name                    = module.bastion_key_pair.0.this_key_pair_key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.security_group_bastion.0.security_group_id]
  user_data                   = local.user_data

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 20
    }
  ]

  tags = tomap(
    {
      "Environment" = var.environment
    },
  )
}
