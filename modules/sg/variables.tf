variable "vpc_data" {
  type = object({
    id = string
  })
}

variable "web" {
  type = bool
  default = false
}

variable "nat" {
  type = bool
  default = false
}

variable "environment" {
  type = string
}
