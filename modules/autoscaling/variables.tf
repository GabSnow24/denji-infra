variable "template_data" {
   type = object({
      name = string
      key_name = string
    })
}

variable "security_group" {
  type = object({
      id = string
    })
}

variable "subnets" {
  type = object({
    first = string
    second = string
  })
}

variable "size" {
  type = object({
    max = number
    min = number
    desired = number
  })

  default = {
    desired = 1
    max = 2
    min = 1
  }
}



variable "aws_variables" {
  type = object({
    "AWS_ACCESS_KEY" = string
    "AWS_SECRET_KEY" = string
    "AWS_REGION"     = string
  })
}

variable "as_group_data" {
  type = object({
      name = string
      tg_arn = string
    })
}

variable "container_data"{
   type = object({
    port = string
    name = string
  })
}

variable "bootstrap_bash" {
  type=string
  default = <<EOF
#!/bin/bash

##INSTALL PACKAGES
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -m 0755 -p /etc/apt/keyrings

##INSTALL DOCKER
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get --assume-yes install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt-get install unzip

##INSTALL AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#SET ARGS IN VARIABLES
AWS_ACCESS_KEY_ID=${var.aws_variables.AWS_ACCESS_KEY}
AWS_SECRET_KEY=${var.aws_variables.AWS_SECRET_KEY}
AWS_REGION=${var.aws_variables.AWS_REGION}

##CONFIGURE AWS CLI
aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_KEY
aws configure set region $AWS_REGION
ACCOUNT_NUMBER=$(aws sts get-caller-identity --query Account --output text)

##CONFIGURE DOCKER
docker login -u AWS -p $(aws ecr get-login-password) $ACCOUNT_NUMBER.dkr.ecr.$AWS_REGION.amazonaws.com
mkdir app
cd app
version: '3.9'
services:
  app:
    container_name: app
    image: $ACCOUNT_NUMBER.dkr.ecr.$AWS_REGION.amazonaws.com/${var.container_data.name}
    ports:
      - '80:${var.container_data.port}'
' > docker-compose.yml
docker compose up -d
EOF
}