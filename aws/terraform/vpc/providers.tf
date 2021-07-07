provider "aws" {
  region = var.region
  default_tags {
   tags = var.additional_tags
 }
}


data "aws_region" "current" {}
data "aws_availability_zones" "available" {}