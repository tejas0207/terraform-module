variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string

}
variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string

}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool

}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool

}


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = string
}

variable "public1_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string

}

variable "public2_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string

}


variable "env" {
  type        = string
}
