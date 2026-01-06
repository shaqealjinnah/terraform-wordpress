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

variable "instance_type" {
    type = string
    description = "Type of Instance used"
}

variable "key_name" {
    type = string
    description = "EC2 key pair name for SSH access"
}