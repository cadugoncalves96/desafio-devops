variable minimum_scale {
    description = "The minimum scale the autoscaling group can scale down. The default is 1, so the minimum ec2 running is 1."
    default = 1
    type = number
}

variable maximum_scale {
    description = "The maximum scale the autoscaling group can scale up. The default is 3, so the maximum ec2 running is 3."
    default = 3
    type = number
}

variable desired_scale {
    description = "The desired scale the autoscaling group will execute. The default is 1, so the default running machines is 1."
    default = 1
    type = number    
}

variable instance_type {
    description = "Which size of ec2 instance to use. The default is t3.micro."
    default = "t3a.micro"
    type = string   
}

variable app {
    description = "The app name. Used to tag resources, and name resources."
    type = string
}

variable "app_tag" {}

variable instance_key_name {
    description = "The keypair used to access the ec2 instances."
    type = string
}

variable env {
    description = "The environment to use. E.g. 'staging', 'production' or 'sandbox'. It's used to retrieve important info about which subnet to use, and so on."
    type = string    
}

variable "lb_certificate" {
    description = ""
    type = string
}

variable "domain_name" {
    description = ""
    type = string
}

variable "public_subnet_ids" {
    description = ""
}

variable "vpc_id" {
    description = ""
    type = string
}

variable "private_subnet_ids" {
    description = ""
}

variable "region" {
    description = ""
    type = string
}

variable "api_name" {}