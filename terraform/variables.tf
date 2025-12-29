variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "app_port" {
  type    = number
  default = 80
}

# (Optional but recommended) Put your home IP like "x.x.x.x/32"
variable "ssh_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
