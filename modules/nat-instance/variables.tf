variable "instance_data" {

   type = object({
    az = string
    key_name = string
    type = string 
    subnet_id = string 
    name = string
  })
  description = "The instance data that is needed to create the resource."
}

variable "vpc_data" {
  type = object({
       id = string
    })
  description = "The VPC id for Nat SG"
}
