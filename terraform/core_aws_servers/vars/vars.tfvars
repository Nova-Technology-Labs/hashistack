masters_configuration = {
  "master-1" = {
    name              = "master-1"
    aws_az            = "eu-west-3a"
    aws_volume_type   = "gp3"
    aws_volume_size   = 8
    aws_delete_on_termination = "true"
  },
  "master-2" = {
    name              = "master-2"
    aws_az            = "eu-west-3b"
    aws_volume_type   = "gp3"
    aws_volume_size   = 8
    aws_delete_on_termination = "true"
  },
  "master-3" = {
    name              = "master-3"
    aws_az            = "eu-west-3c"
    aws_volume_type   = "gp3"
    aws_volume_size   = 8
    aws_delete_on_termination = "true"
  }
}

aws_minions_volume_type           = "gp3"
aws_minions_volume_size           = 8
aws_minions_az                    = "eu-west-3a"
aws_minions_delete_on_termination = "true"
