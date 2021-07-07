output "region" {
  description = "AWS Region"
  value       = var.region
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "bastion-host-public-ip" {
  value = aws_eip.bastion.0.public_ip
}

output "bastion_host_pem_file" {
  description = "Warning!! ! Please Save this for future use !"
  value       = nonsensitive(tls_private_key.bastion.0.private_key_pem)
}

output "bastion_host_info_pem" {
  value = "SAVE THIS FILE AS .pem FOR ACCESSING BASTION HOST"
}

output "local_file" {
  description = "Path of pem file"
  value       = format("%s-%s", path.module, "bastion_private_keypair.pem")
}
