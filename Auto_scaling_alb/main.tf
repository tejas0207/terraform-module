 provider "aws" {
  region = "ap-south-1"
}

resource "tls_private_key" "pk" {
  algorithm                        = "RSA"
  rsa_bits                         = 4096
}

resource "aws_key_pair" "kp" {
  key_name                         = var.key_name      
  public_key                       = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename                          = "./ssh_keys/${aws_key_pair.kp.key_name}.pem"  
  content                           = tls_private_key.pk.private_key_pem
  file_permission                   = "600"
}


resource "aws_launch_configuration" "as_conf" {
    iam_instance_profile             = var.lc_instance_profile
    image_id                         = var.launch_configuration_imageid
    instance_type                    = var.instance_type
    key_name                         = var.key_name
    name                             = var.launch_configuration_name
    security_groups                  = var.launch_configuration_sg
    user_data                        = var.launch_configuration_userdata
    root_block_device {
        delete_on_termination = true
        encrypted             = false
        iops                  = 0
        throughput            = 0
        volume_size           = 8
        volume_type           = "gp2"
    }
}


resource "aws_lb_target_group" "test" {
    deregistration_delay          = "300"
    load_balancing_algorithm_type = "round_robin"
    name                          = "sil-tg"
    port                          = var.alb_tg_port
    protocol                      = "HTTP"
    protocol_version              = "HTTP1"
    target_type                   = "instance"
    vpc_id                        = var.target_group_vpc

    health_check {
        enabled             = true
        healthy_threshold   = 5
        interval            = 90
        matcher             = "200"
        path                = "/"
        port                = var.alb_healthcheck_port
        protocol            = "HTTP"
        timeout             = 60
        unhealthy_threshold = 5
    }

    stickiness {
        cookie_duration = var.alb_stickiness
        enabled         = false
        type            = "lb_cookie"
    }
}


resource "aws_lb" "test" {
    drop_invalid_header_fields = false
    enable_deletion_protection = false
    enable_http2               = true
    enable_waf_fail_open       = false
    idle_timeout               = 60
    internal                   = false
    ip_address_type            = "ipv4"
    load_balancer_type         = "application"
    name                       = var.aws_lb_name
    security_groups            = var.lb_sg
    subnets                    = var.lb_subnets
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = var.alb_listner_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
  depends_on = [
        aws_lb.test,
    ]
}

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  custom_suffix    = "test"
}


resource "aws_autoscaling_group" "web" {
    name                      = var.autoscaling_group_name
    capacity_rebalance        = false
    default_cooldown          = 300
    desired_capacity          = var.alb_desired_instance
    health_check_grace_period = 300
    health_check_type         = "EC2"
    max_instance_lifetime     = 0
    max_size                  = var.alb_maximum_instance
    metrics_granularity       = "1Minute"
    min_size                  = var.alb_minimum_instance
    protect_from_scale_in     = false
    service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.id
    target_group_arns         = [aws_lb_target_group.test.arn]
    vpc_zone_identifier       = var.vpc_subnets
    launch_configuration      = aws_launch_configuration.as_conf.name
    tag {
    key                       = "Name"
    value                     = "sil-server"
    propagate_at_launch       = true
    }
}
resource "aws_autoscaling_policy" "example" {
  name                   = "sil-autoscalling-policy"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"


  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.scaling_target_value
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  alb_target_group_arn   = aws_lb_target_group.test.arn
}

