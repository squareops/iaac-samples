# Terraform Automation for AWS VPC

This automation creates a secure VPC with
1. Public and Private Subnets
2. NAT Gateway, Internet Gateway, Route tables etc. 
3. A Jump Server ( or Bastion Host ) to securely access resources to be deployed in this VPC later

The example assumes you have already deployed state storage backend using AWS S3 and DynamoDb. This step can be skipped for development and testing purpose by commenting the contents of backend.tf file

### Pre-requisites
1. Terraform 1.0.0 :- https://www.terraform.io/docs/cli/install/apt.html
2. Aws CLI V2:- https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html
3. AWS Account Login Credentials ( using CLI Credentials, or IAM ROLE when running from an EC2 instance )

## Deployment Instructions
### Deploy a new VPC

1. Configure AWS CLI - https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html

2. Configure deployment input variables in *terraform.tfvars* file. ( Like AWS Region, CIDRs, Bastion Instance type etc. )

3. Initialize terraform 
    ```
    terraform init
    ```
3. Create a deployment plan
    ```
    terraform plan -out plan.out
    ```
    Note: Analyse the plan and check the resources which will be created when this plan gets applied

5. Apply the changes to create a new VPC and it's components
    ```
    terraform apply plan.out
    ```
### Make changes to VPC created above
1. Make changes to *terraform.tfvars* file
2. Create a deployment plan
    ```
    terraform plan -out plan-<version>.out
    ```
    Note: Analyse the plan and check the resources to be replaced when this plan gets applied

5. analyze the plan and apply the changes
    ```
    terraform apply plan.out
    ```
### Cleanup 
1. Run terraform destroy command to cleanup. Make sure to remove any resources first which are using the resources deployed as a part of this stack
    ```
    terraform destroy
    ```
This will cleanup the resources in your AWS account and generate a tfstate.backup which depicts the last know good state that was deployed before cleanup. This backup file can be used to recreate the previous state in case needed
