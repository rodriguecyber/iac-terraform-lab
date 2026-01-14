

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
git clone <your-lab-repo-url>
cd IaCwithterraform

Step 2: Initialize Terraform
terraform init


Installs required providers (AWS, TLS, Local)

Uses local state by default (can be configured to S3 + DynamoDB backend)

No prompts appear since all values are provided in the configuration.

Step 3: Review the Plan
terraform plan


Terraform shows all resources it will create:

VPC, Subnet, IGW, Route Table

Security Group (SSH + HTTP)

Key Pair (generated automatically)

EC2 Instance

Step 4: Apply the Plan
terraform apply -auto-approve


Creates all resources automatically

Generates an SSH key pair:

Public key uploaded to AWS

Private key saved locally as lab-key.pem

Launches a t2.micro EC2 instance in a public subnet

Step 5: Access the EC2 Instance

Set proper permissions on the private key:

chmod 600 lab-key.pem


SSH into the instance:

ssh -i lab-key.pem ec2-user@<ec2-public-ip>


<ec2-public-ip> is output by Terraform after apply (terraform output ec2_public_ip)

Step 6: Outputs

Terraform automatically outputs:

Output Name	Description
vpc_id	ID of the created VPC
public_subnet_id	ID of the public subnet
ec2_instance_id	ID of the EC2 instance
ec2_public_ip	Public IP of the EC2 instance
private_key_path	Path to the private key for SSH access
Step 7: Cleanup
terraform destroy -auto-approve


Removes all resources created by this lab

Deletes EC2, Key Pair, VPC, Subnet, IGW, Security Group

Ensures no unnecessary AWS costs are incurred.

Optional: Backend (S3 + DynamoDB)

For collaborative environments, you can configure a remote backend:

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "ec2-lab/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}


State file is stored in S3

DynamoDB table provides locking to prevent multiple users modifying state simultaneously

Avoids interactive prompts by using hardcoded values or -backend-config parameters

Notes

No manual SSH key generation is required; Terraform handles it automatically.

All resources are Free Tier compatible.

Terraform automatically manages dependencies (SG → Subnet → EC2).

Best practice: restrict SSH access to your IP in production instead of 0.0.0.0/0.






