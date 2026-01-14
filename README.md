

# Terraform Lab: Deploying EC2 in a Public Subnet with Automatic Key Pair

## Lab Overview

In this lab, we use **Terraform** to deploy a **t3.micro EC2 instance** inside a **public subnet** on a new **VPC**.  

All resources are created automatically, including:  

- VPC, Subnet, Internet Gateway, Route Table  
- Security Group allowing SSH (22) and HTTP (80)  
- EC2 Key Pair (generated automatically by Terraform if missing)  
- EC2 Instance (Amazon Linux 2)  

The Terraform configuration also saves the **private key locally** for SSH access, removing any manual steps.

---

## Prerequisites

1. **AWS Account** (Free Tier recommended)  
2. **AWS CLI configured** with access keys (`aws configure`)  
3. **Terraform installed** (v1.5 or later recommended)  
4. **Git / Terminal**  

Optional: WSL for Windows users or Linux/macOS terminal.

---

## Step 1: Clone the Lab Repository

```bash
git clone https://github.com/rodriguecyber/iac-terraform-lab
cd iac-terraform-lab

step 2: Create backend variables **backend.tfvars**
touch backend.tfvars
(look the variables format in ./backend.tfvars.example)

Step 3: Initialize Terraform
 terraform init -backend-config=backend.tfvars

Installs required providers (AWS, TLS, Local)

Uses local state by default (can be configured to S3 + DynamoDB table )

No prompts appear since all values are provided in the configuration( in backend.tfvar).

Step 3: Review the Plan
terraform plan


Terraform shows all resources it will create:

VPC, Subnet, IGW, Route Table

Security Group (SSH + HTTP)

Key Pair (generated automatically)

EC2 Instance

Step 4: Apply the Plan
terraform apply 


Creates all resources automatically

Generates an SSH key pair:

Public key uploaded to AWS

Private key saved locally as lab-key.pem

Launches a t3.micro EC2 instance in a public subnet (our sandbox does not support t2.micro ao i used t3.micro)


Step 6: Outputs

Terraform automatically outputs:

Output Name	Description
vpc_id	ID of the created VPC
public_subnet_id	ID of the public subnet
ec2_instance_id	ID of the EC2 instance
ec2_public_ip	Public IP of the EC2 instance
private_key_path	Path to the private key for SSH access

Step 6: Cleanup
terraform destroy -auto-approve


Removes all resources created by this lab

Deletes EC2, Key Pair, VPC, Subnet, IGW, Security Group


 Backend (S3 + DynamoDB)

For collaborative environments,  configure a remote backend:

terraform {
  backend "s3" { }
}


State file is stored in S3

DynamoDB table provides locking to prevent multiple users modifying state simultaneously

Avoids interactive prompts by using hardcoded values or -backend-config parameters

NB: for Backend resources IaC refer: https://github.com/rodriguecyber/backend-resources-IaC






