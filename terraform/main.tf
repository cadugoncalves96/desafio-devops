terraform {
  required_version  = ">= 0.12.9"
}

provider "aws" {
    region          = var.env
}

terraform {
  backend "s3" {
    bucket          = "my-terraform-states"
    key             = "api.tfstates"
    region          = "us-east-1"
  }
}

module "compute" {
  source = "./modules/compute"
  env               = var.env
  app               = var.app
  minimum_scale     = var.minimum_scale
  maximum_scale     = var.maximum_scale
  desired_scale     = var.desired_scale
  target_group_arn  = module.loadbalancing.target_group_arn
  target_subnet_ids = var.private_subnet_ids
  lc_sec_group      = module.security.sg_app_id
  instance_key_name = var.instance_key_name
  instance_type     = var.instance_type
}

module "loadbalancing" { 
  source = "./modules/loadbalancing"
  env                   = var.env
  app                   = var.app
  lb_sec_group          = module.security.sg_alb_id
  target_subnet_ids     = var.public_subnet_ids
  vpc_id                = var.vpc_id
  domain_name           = var.domain_name
  lb_certificate        = var.lb_certificate
}

module "security" { 
  source = "./modules/security"
  env                   = var.env
  app                   = var.app
  vpc_id                = var.vpc_id
}

module "scale_rules" { 
  source = "./modules/scale_rules"
  app                   = var.app
  asg_name              = module.compute.asg_name
}