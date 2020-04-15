output sg_app_id {
    value = aws_security_group.security_group_app.id
}

output sg_alb_id {
    value =  aws_security_group.sg_app_loadbalancer.id
}