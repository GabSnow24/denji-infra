module "autoscaling"{
  ##ALTERAR SOURCE
  source = "../autoscaling"
  template_data = {
    ##ALTERAR VAR
    name = "var.app_name-template"
    key = "var.app_key" 
  }

  security_group = {
    id = module.security_group.web_sg.id
  }

  subnets = {
    first = module.network.private_subnet_1_id
    second = module.network.private_subnet_2_id
  }

  ##ALTERAR VAR
  size = var.autoscaling_size_metrics

  ##ALTERAR VAR
  aws_variables = var.aws_variables

  as_group_data = {
    ##ALTERAR VAR
    name = "var.app_name-group"
    tg_arn = module.load_balancer.tg_arn
  }

  container_data = {
    port = "var.app_port"
    name = "var.app_name"
  }


}

module "load_balancer"{
  ##ALTERAR SOURCE
  source = "../loadbalancer"
  ##ALTERAR VAR
  lb_data = {
    name = "var.app_name-lb"
    certificate_arn = "var.app_certificate"
  }
  security_group = {
    web = {
      id = module.security_group.web_sg.id
    }
  }
  ##ALTERAR VAR
  tg_data = {
    name = "var.app_name-tg"
    health_check_endpoint = "/health"
    network = {
      vpc_id = module.network.vpc_id
    }
  }

  #ALTERAR VAR
  container_data = {
    port = "var.app_port"
  }
  subnets = {
    first = module.network.public_subnet_1_id
    second = module.network.public_subnet_2_id
  }
}


module "nat_instance" {
      ##ALTERAR SOURCE
      source = "../nat-instance"
      #ALTERAR VAR
      instance_data = {
        az = var.aws_region
        name = "NAT/BASTION-Prod"
        subnet_id = module.network.public_subnet_1_id
        type = "t2.micro"
      }
      vpc_data = {
        id = module.network.vpc_data.id
      }
    }

module "security_group"{
  ##ALTERAR SOURCE
  source = "../sg"
  vpc_data = {
    id = module.network.vpc_data.id
  }
  web = true
  #ALTERAR VAR
  environment = "var.enviroment"
}

module "network" {
  #ALTERAR SOURCE
  source              = "../network"
  #ALTERAR VAR
  vpc_data = {
    name = "VPC var.app_name"
  }
#ALTERAR VAR
  availability_zones = {
    first = "var.app_az"
    second = "var.app_az"
  }

  nat_instance_id = module.nat_instance.id
}
