resource "aws_launch_template" "launch-template" {
  name      = var.template_data.name
  image_id  = "ami-00874d747dde814fa"
  key_name  = var.template_data.key_name
  user_data = "${base64encode(var.bootstrap_bash)}"
  vpc_security_group_ids = [
    var.security_group.id
  ]

  depends_on = [
   var.security_group
  ]
}


resource "aws_autoscaling_group" "as-group" {
 vpc_zone_identifier       = [var.subnets.first, var.subnets.second]
  name                      = var.as_group_data.name
  capacity_rebalance        = true
  desired_capacity          = var.size.desired
  health_check_grace_period = 300
  health_check_type         = "EC2"
  max_size                  = var.size.max
  min_size                  = var.size.min
  enabled_metrics = [
    "GroupAndWarmPoolDesiredCapacity",
    "GroupAndWarmPoolTotalCapacity",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances",
    "WarmPoolDesiredCapacity",
    "WarmPoolMinSize",
    "WarmPoolPendingCapacity",
    "WarmPoolTerminatingCapacity",
    "WarmPoolTotalCapacity",
    "WarmPoolWarmedCapacity",
  ]
  target_group_arns = [
    var.as_group_data.tg_arn
  ]
  mixed_instances_policy {

    instances_distribution {

      on_demand_allocation_strategy            = "prioritized"
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "price-capacity-optimized"
      spot_instance_pools                      = 0
      spot_max_price                           = ""

    }
    launch_template {
      launch_template_specification {

        launch_template_id   = aws_launch_template.launch-template.id
        launch_template_name = aws_launch_template.launch-template.name
        version              = "$Latest"

      }
      override {
        instance_type = "t3.micro"
      }

      override {
        instance_type = "t2.micro"
      }

      override {
        instance_type = "t2.small"
      }

    }
  }
  depends_on = [
    aws_launch_template.launch-template,
    var.as_group_data
  ]
}


