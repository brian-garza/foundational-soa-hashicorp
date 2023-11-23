data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

resource "aws_launch_template" "container_instance" {
  description            = "launch template for ECS container instances"
  image_id               = data.aws_ssm_parameter.ecs_optimized_ami.value
  instance_type          = var.instance_type
  key_name               = aws_key_pair.boundary.key_name
  name_prefix            = "${var.region}-ecs-instance"
  vpc_security_group_ids = [
    aws_security_group.container_instance.id,
    aws_security_group.consul_client.id,
    module.boundary_worker.0.security_group_id
  ]

  iam_instance_profile {
    arn = var.container_instance_profile
  }

  monitoring {
    enabled = true
  }

  user_data = base64encode(templatefile("${path.module}/scripts/container_instance.sh", {
    ECS_CLUSTER_NAME = aws_ecs_cluster.main.name
  }))
}

# resource "aws_autoscaling_group" "container_instance" {
#   health_check_type     = "EC2"
#   max_size              = 0
#   min_size              = 0
#   name_prefix           = "${var.region}-ecs-instance"
#   protect_from_scale_in = false
#   target_group_arns     = []
#   vpc_zone_identifier   = module.network.vpc_private_subnet_ids

#   enabled_metrics = [
#     "GroupMinSize",
#     "GroupMaxSize",
#     "GroupDesiredCapacity",
#     "GroupInServiceInstances",
#     "GroupPendingInstances",
#     "GroupStandbyInstances",
#     "GroupTerminatingInstances",
#     "GroupTotalInstances",
#     "GroupInServiceCapacity",
#     "GroupPendingCapacity",
#     "GroupStandbyCapacity",
#     "GroupTerminatingCapacity",
#     "GroupTotalCapacity"
#   ]

#   instance_refresh {
#     strategy = "Rolling"
#   }

#   launch_template {
#     id      = aws_launch_template.container_instance.id
#     version = aws_launch_template.container_instance.latest_version
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   tag {
#     key                 = "Name"
#     value               = "${var.region}-ecs-instance"
#     propagate_at_launch = true
#   }
# }