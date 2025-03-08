# SuperBank 

Welcome to the SuperBank application. The following guide will help to deploy the core banking application to the AWS envinroments.

## Pre-requisite

1. Install Terraform 
- Official guide - https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli 
- Using tfenv - https://github.com/tfutils/tfenv

## Folder

```
.
├── apps
├── environments
├── modules
│   ├── instance-profile-dynamodb
│   └── self-signed-acm
└── user-data
```

- apps: Contain python REST API application. 
- environments: Contains environment-specific configurations.
- modules: Contains reusable Terraform modules.
- user-data: Contains bootstrap script for autoscaling group.

## Provisioning

Run `terraform init` then `terraform plan` to see what will be created, finally if it looks good run terraform apply

```sh
terraform init
terraform plan
terraform apply --auto-approve
```

## Tfvars

Using `.tfvars` files in Terraform allows you to manage and organize your variable values separately from your main configuration files. This is particularly useful for managing different environments (e.g., development, staging, production).

Step-by-Step Guide to Using `.tfvars` Files

Create a `.tfvars` File: Create a `.tfvars` file to store your variable values. For example, `development.tfvars`:

```sh
# development.tfvars
region               = "us-west-2"
environment          = "development"
asg_min_size         = 2
asg_max_size         = 2
asg_desired_capacity = 2

create_jumphost = true
```

Use the .tfvars File with Terraform Commands: When running Terraform commands, specify the .tfvars file using the -var-file option:

```sh
terraform init
terraform plan -var-file=environments/development.tfvars
terraform apply -var-file=environments/development.tfvars
```

Cleanup: To destroy the infrastructure using the same .tfvars file:

```sh
terraform destroy -var-file=environments/development.tfvars
```

## Testing your application

Once the infrastrucutre is provisioned. You can perform curl to the ALB dns. ALB can be queries from the Terraform outputs. 

```sh
Apply complete! Resources: 61 added, 0 changed, 0 destroyed.

Outputs:

alb_dns_name = "mybank-development-alb-168351812.ap-southeast-1.elb.amazonaws.com"
```

```sh
~/Downloads/00/superbank main
(base) ❯ curl -k -X POST https://mybank-development-alb-168351812.ap-southeast-1.elb.amazonaws.com/transaction -H "Content-Type: application/json" -d '{"amount": 100, "type": "deposit"}'
{"message":"Transaction successful"}
```

```sh
~/Downloads/00/superbank main
(base) ❯ curl -k https://mybank-development-alb-168351812.ap-southeast-1.elb.amazonaws.com
{"balance":"100"}
```

```sh
~/Downloads/00/superbank main
(base) ❯ curl -k -X POST https://mybank-development-alb-168351812.ap-southeast-1.elb.amazonaws.com/transaction -H "Content-Type: application/json" -d '{"amount": 900, "type": "deposit"}'
{"message":"Transaction successful"}
```

```sh
~/Downloads/00/superbank main
(base) ❯ curl -k https://mybank-development-alb-168351812.ap-southeast-1.elb.amazonaws.com
{"balance":"1000"}
```