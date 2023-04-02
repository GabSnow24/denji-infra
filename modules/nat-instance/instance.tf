resource "aws_instance" "nat_instance" {
  ami                         = "ami-04e5df0cf5946b2a4"
  associate_public_ip_address = true
  availability_zone           = var.instance_data.az
  instance_type               = var.instance_data.type
  key_name  = var.instance_data.key_name
  source_dest_check                    = false
  subnet_id                   = var.instance_data.subnet_id
  vpc_security_group_ids = [
    module.security_group.nat_sg.id
  ]

  depends_on = [
    module.security_group.nat_sg
  ]
  tags = {
    Name = var.instance_data.name
  }
}