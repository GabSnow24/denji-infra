variable "vpc_data" {
   type = object({
    name = string
  })
}

variable "nat_instance_id" {
  type = string
}

variable "availability_zones" {
 type = object({
    first = string
    second = string
  })
}

variable "environment" {
  type = string
}