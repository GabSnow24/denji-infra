variable "lb_data" {
  type = object({
    name = string
    certificate_arn = string
  })
}

variable "security_group" {
  type = object({
    web = object({
      id = string
  })
  })
}

variable "container_data"{
   type = object({
    port = string
  })
}

variable "tg_data" {
  type = object({
    name = string
    health_check_endpoint = string
    network = object({
      vpc_id = string
  })
  })

  default = {
    name = ""
    health_check_endpoint = "/"
    network = {
      vpc_id = ""
    }
  }
}

variable "subnets" {
  type = object({
    first = string
    second = string
  })
}

