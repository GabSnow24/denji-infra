# Network Module for Secure Archtecture (Private, Public and Nat Gateway)

This module uses Terraform code that uses an [EC2 Instance](https://aws.amazon.com/ec2) to deploy 
a [Nat Instance](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html#NATSG) in [AWS](https://aws.amazon.com/). The instance consists in a community made AMI.
The instance is responsible for manage traffic from other instances or services in a [Private Network](https://en.wikipedia.org/wiki/Private_network), to the internet.

![NAT Instance architecture](https://github.com/GabSnow24/nat-instance-tf/blob/70d981397dae1fe00168230e0c9c74dba29f0d3a/archtecture-example.jpg?raw=true)

You will need to have a ECS Task, AutoScaling Group or any other service that runs in a private network created, in order to use the NAT Instance properly.

## Quick start

To deploy a Nat Instance:

1. Create your terraform repo in your computer (if doesnt exists).
1. Install [Terraform](https://www.terraform.io/).
1. Create a [terraform module](https://developer.hashicorp.com/terraform/language/modules/syntax) inside your terraform repository
1. Point the source property in module to [Module's GitHub](https://github.com/GabSnow24/nat-instance-tf) using release tags (recommended), example:
    ```
    module "nat_instance" {
      source = "git::https://github.com/GabSnow24/nat-instance-tf?ref=v0.0.1"
      [...]
    }
    ```
1. Pass the parameters specified and necessary to run the module. Parameteres are (all of them are mandatory):
    * instance_data (object)
        * az (Availability Zone)
        * key_name (The ssh key to access the instance)
        * type (The Type of the EC2 instance)
        * subnet_id (The private subnet to manage traffic from)
        * name (The name of the instance)
    * security_group (object)
        * id (Security group ID)
    ```
    module "nat_instance" {
      source = "git::https://github.com/GabSnow24/nat-instance-tf?ref=v0.0.2"
      instance_data = {
        az = "us-east-1a"
        name = "NAT/BASTION-Prod"
        subnet_id = aws.subnet.public.id
        type = "t2.micro"
      }
      security_group = {
        id = aws_security_group.web.id
      }
    }
    ```
1. Run `terraform init`.
1. Run `terraform plan`.
1. Run `terraform apply`.

