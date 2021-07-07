# Enable state storage backend using S3 and DynamoDB
terraform {
  backend "s3" {
    bucket         = ""
    key            = "terraform-stack-0/network/terraform.tfstate"
    region         = ""
    dynamodb_table = ""
  }
}
