variable "fruits_details" {
  default = {
    apple  = {
      stock = 100
    }
    grapes = {
      price = 5
    }
  }
}

output "looking_for" {
  value = lookup(var.fruits_details["grapes"],"price", 9)
}