variable "launch_configuration_sg" {
  type        = list(string)
}

variable "launch_configuration_name" {
  type        = string
}

variable "launch_configuration_userdata" {
  type        = string
  description = "User data with base 64 endoded format"
}

variable "target_group_vpc" {
  type        = string
}

variable "lb_sg" {
  type        = list(string)
}

variable "vpc_subnets" {
  type        = list(string)
}

variable "lb_subnets" {
  type        = list(string)
}

variable "autoscaling_group_name" {
  type        = string

}

variable "launch_configuration_imageid" {
  type        = string
}
variable "instance_type" {
  type        = string
}

variable "key_name" {
  type        = string
  description = "key name for launch configuration image"
}

variable alb_tg_port {
  type        = number
  description = "port number of ec2 instance on which server will be running"
}

variable alb_healthcheck_port {
  type        = number
  description = "port number of ec2 instance on which server will be running"
}

variable alb_listner_port {
  type        = number
  description = "port number of alb(http/https)"
}

variable alb_stickiness {
  type        = number
  description = "stickiness or cookie_duration in seconds"
}

variable aws_lb_name {
  type        = string
  description = "loadbalancer name"
}

variable scaling_target_value {
  type        = number
  description = "% of cpu utilization to scaleup in autoscaling group"
}

variable lc_instance_profile {
  type        = string
  description = "instance profile to be attached to instances"
}

variable alb_desired_instance {
  type        = number
  description = "desired number of instance to be launched"
}

variable alb_minimum_instance {
  type        = number
  description = "minimum number of instance to be launched"
}

variable alb_maximum_instance {
  type        = number
  description = "maximum number of instance to be launched"
}


