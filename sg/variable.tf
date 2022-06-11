variable "security_group_name" {
  type = string
}

variable "security_group_desc" {
  type = string
}

variable "vpc_id" {
    type = string
}

variable "sg_ingress_rules" {
  type = list
  # default = [
  #   {
  #     ingress_port = 80
  #     protocol = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #     ipv6_cidr_blocks = ["::/0"]
  #     description = "allow_http"
  #   },
}

variable "tags" {
  type = map(string)
  default = {
    "Name" = ""
  }
}