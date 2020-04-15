resource "aws_autoscaling_policy" "scalingpolicy-up" {
    name                   = "${var.app} - terraform-scalingpolicy-up"
    scaling_adjustment     = 1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    autoscaling_group_name = "${var.asg_name}"
}

resource "aws_autoscaling_policy" "scalingpolicy-down" {
    name                   = "${var.app} - terraform-scalingpolicy-down"
    scaling_adjustment     = -1
    adjustment_type        = "ChangeInCapacity"
    cooldown               = 300
    autoscaling_group_name = "${var.asg_name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm-up" {
    alarm_name          = "${var.app} - terraform-alarm-cpu-up"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "120"
    statistic           = "Average"
    threshold           = "50"

    dimensions = {
        AutoScalingGroupName = "${var.asg_name}"
    }

    alarm_description = "This metric monitor EC2 instance cpu utilization"
    alarm_actions     = [aws_autoscaling_policy.scalingpolicy-up.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpualarm-down" {
    alarm_name          = "${var.app} - terraform-alarm-cpu-down"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = "120"
    statistic           = "Average"
    threshold           = "40"

    dimensions = {
        AutoScalingGroupName = "${var.asg_name}"
    }

    alarm_description = "This metric monitor EC2 instance cpu utilization"
    alarm_actions     = [aws_autoscaling_policy.scalingpolicy-down.arn]
}