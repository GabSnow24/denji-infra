resource "aws_security_group" "web" {
  count = var.web ? 1 : 0
  name        = "web-sg"
  description = "Web Security Group"
  vpc_id      = var.vpc_data.id

  egress = [
    {
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]

  ingress = [
    {
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    },
    {
      description      = ""
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["172.31.2.0/24", "172.31.3.0/24"]
    }

  ]
  depends_on = [
    var.vpc_data
  ]

  tags = {
    "Name"       = "Web-Sg"
    "Resource"   = "SecurityGroup"
    "Enviroment" = var.environment
  }
}

resource "aws_security_group" "nat" {
  count = var.nat ? 1 : 0
  name        = "NATSecurityGroup"
  description = "NAT Instance SG"
  vpc_id      = var.vpc_data.id

  egress = [
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "Allow outbound HTTP access to the internet"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "Allow outbound HTTPS access to the internet"
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    },
    {
      cidr_blocks = [
        "172.31.1.0/24",
        "172.31.0.0/24",
      ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      description      = "Allow outbound MySQL access to the internet"
      from_port        = 5432
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 5432
    },
  ]

  ingress = [
    {
      cidr_blocks = [
        "172.31.0.0/24",
        "172.31.1.0/24",
      ]
      description      = "Allow inbound HTTPS traffic from servers in the private subnet"
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    },
    {
      cidr_blocks = [
        "172.31.0.0/24",
        "172.31.1.0/24",
      ]
      description      = "Allow inbound HTTP traffic from servers in the private subnet"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    },
    {
      cidr_blocks = [
        "172.31.1.0/24",
        "172.31.0.0/24",
      ]
      description      = "Allow inbound SSH access to the NAT instance from your network (over the internet gateway)"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks = [
        "172.31.1.0/24",
        "172.31.0.0/24",
      ]
      description      = "Allow inbound MySQL access to the NAT instance from your network (over the internet gateway)"
      from_port        = 5432
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 5432
    },
  ]

  depends_on = [
    var.vpc_data
  ]

  tags = {
    Enviroment = var.environment,
    Name       = "NATG-SG",
    Resource   = "SecurityGroup"
  }
}
