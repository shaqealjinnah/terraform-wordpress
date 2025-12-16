variable "aws_region" {
    type = string
    description = "AWS Region"
}

variable "vpc_cidr" {
    type = string
    description = "CIDR for VPC"
    default = "10.0.0.0/16"
}

variable "admin_ip" {
    type  = string
    description = "My IP address"
}