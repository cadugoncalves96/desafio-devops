resource "aws_security_group" "security_group_app" {
  name          = "${var.app}-${var.env}"
  description   = "Grupo de seguranca do App ${var.app}"
  vpc_id        = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app}"
    App         = "${var.app}"
    Env         = "${var.env}"
  }

}

resource "aws_security_group" "sg_app_loadbalancer" {
  name        = "alb-${var.app}"
  description = "Grupo de seguranca do ALB - ${var.app}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "alb-${var.app}"
  }
}