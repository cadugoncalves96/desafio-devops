region = "us-east-1"
app = "ping-pong"
env = "production"
app_tag = "latest"

vpc_id = "vpc-b64552cd"
public_subnet_ids = ["subnet-0e8e5820","subnet-0e8e5820","subnet-35499c69"]
private_subnet_ids = ["subnet-4f2bfa28","subnet-4f3ddb71","subnet-8c930bc6"]

minimum_scale = "1"
maximum_scale = "1"
desired_scale = "1"
instance_type = "t3a.micro"
instance_key_name = "chave-mestra"

lb_certificate = "arn:aws:acm:us-east-1:355903221802:certificate/3963b5d3-de23-40df-8c55-5b69fe99c563"
domain_name = "caduzerando.com"
api_name = "api"
