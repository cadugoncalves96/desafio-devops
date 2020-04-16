data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "launch_config" {
  image_id                    = data.aws_ami.ubuntu.image_id
  instance_type               = var.instance_type
  key_name                    = var.instance_key_name
  security_groups             = [var.lc_sec_group]
  user_data                   = templatefile("./user_data/config.sh", { env = "${var.env}", app_tag = "${var.app_tag}" })
  
  lifecycle {
    create_before_destroy     = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name                  = "${var.app} - ${aws_launch_configuration.launch_config.name}"
  max_size              = var.maximum_scale
  min_size              = var.minimum_scale
  desired_capacity      = var.desired_scale
  health_check_type     = "ELB"
  wait_for_elb_capacity = var.minimum_scale
  launch_configuration  = aws_launch_configuration.launch_config.name
  target_group_arns     = [var.target_group_arn]
  vpc_zone_identifier   = var.target_subnet_ids

  tags = [
    {
      key                 = "Name"
      value               = "${var.app} - ${var.env}"
      propagate_at_launch = true
    },
    {
      key                 = "App"
      value               = "${var.app}"
      propagate_at_launch = true
    },
    {
      key                 = "Env"
      value               = "${var.env}"
      propagate_at_launch = true
    }
  ]

  lifecycle {
    create_before_destroy     = true
  }
}
