# SuperBank 

Welcome to the SuperBank application. The following guide will help to deploy the core banking application to the AWS envinroments.

## Pre-requisite

1. Install Terraform 
- Official guide - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli 
- Using tfenv - https://github.com/tfutils/tfenv

## Provisioning

Run `terraform init` then `terraform plan` to see what will be created, finally if it looks good run terraform apply

```sh
terraform init
terraform plan -var-file=development.tfvars -out=myaws.tfplan
terraform apply myaws.tfplan
```


## Cleanup
You can cleanup the Terraform-managed infrastructure.

```sh
terraform destroy -var-file=development.tfvars
```