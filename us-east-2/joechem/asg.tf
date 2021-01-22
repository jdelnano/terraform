resource aws_launch_template lt {
  name                   = var.name
  image_id               = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  update_default_version = true

  iam_instance_profile {
    name = aws_iam_instance_profile.prof.id
  }

  network_interfaces {
    security_groups = [aws_security_group.ec2.id]
  }

  credit_specification {
    cpu_credits = "standard"
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_type           = "gp3"
      volume_size           = var.volume
      delete_on_termination = true
      encrypted             = true
    }
  }

  block_device_mappings {
    device_name = "/dev/xvdb"

    ebs {
      volume_type           = "gp3"
      volume_size           = var.volume
      delete_on_termination = true
      encrypted             = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.tags
  }

  user_data = filebase64("${path.module}/userdata.sh")
}

resource aws_autoscaling_group asg {
  name = var.name

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  min_size           = var.asg_size
  max_size           = var.asg_size
  availability_zones = ["us-east-2a"]
  health_check_type  = "EC2"

  tags = [
    {
      key                 = "Name"
      value               = var.name
      propagate_at_launch = true
    },
    {
      key                 = "env"
      value               = var.env
      propagate_at_launch = true
    },
  ]
}

resource aws_network_interface eni {
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.ec2.id]
}

resource aws_eip ip {
  vpc               = true
  network_interface = aws_network_interface.eni.id
}
