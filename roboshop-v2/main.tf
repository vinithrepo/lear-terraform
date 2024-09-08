variable "ami" {
  default = "ami-0b4f379183e5706b9"
}
variable "instance_type" {
  default = "t3.small"
}
variable "security_groups" {
  default = [ "sg-0ad8ec6873fafd140" ]
}
variable "zone_id" {
  default = "Z0345275C3S6UDSOR4CU"
}
variable "components" {
  default = {
    frontend = { name = "frontend-dev" }
    mongodb = { name = "mongodb-dev" }
    catalogue = { name = "catalogue-dev" }
    user = { name = "user-dev" }
    cart = { name = "cart-dev" }
    redis = { name = "redis-dev" }
    mysql = { name = "mysql-dev" }
    shipping = { name = "shipping-dev" }
    rabbitmq = { name = "rabbitmq-dev" }
    payment = { name = "payment-dev" }
  }
}


resource "aws_instance" "instance" {
  for_each = var.components
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = var.security_groups

  tags = {
    Name = lookup(each.value,"name", null)
  }
}
resource "aws_route53_record" "frontend" {
  zone_id = var.zone_id
  name    = "${lookup(each.value, "name", null)}.vinithaws.online"
  type    = "A"
  ttl     = 30
  records = [lookup(lookup(aws_instance.instance, each.key, null), "private_ip", null]
}