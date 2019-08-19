locals {

  default_master_config = {
    instance_family    = var.default_master_instance_family
    root_ebs_size      = var.default_master_root_ebs_size
    ami                = coalesce(var.default_master_ami, data.aws_ami.amazonlinux.id)
    subnet_id          = coalesce(var.default_master_subnet_id, var.subnets[0])
    root_volume_type   = var.default_master_root_volume_type
    additional_sg_list = []
    keypair_name       = var.keypair_name
  }

  default_slave_config = {
    instance_family    = var.default_slave_instance_family
    root_ebs_size      = var.default_slave_root_ebs_size
    ami                = coalesce(var.default_slave_ami, data.aws_ami.amazonlinux.id)
    subnet_id          = coalesce(var.default_slave_subnet_id, var.subnets[0])
    root_volume_type   = var.default_slave_root_volume_type
    additional_sg_list = []
    keypair_name       = var.keypair_name
  }

  master_config = [for item in var.master_config : merge(local.default_master_config, item)]
  slave_config  = [for item in var.slave_config : merge(local.default_slave_config, item)]

  https_listeners_count = 1

  https_listeners = [
    {
      "certificate_arn" = var.cert_arn
      "port"            = 443
    },
  ]

  target_groups_count = 1

  target_groups = [
    {
      "name"             = "jenkins"
      "backend_protocol" = "HTTP"
      "backend_port"     = 8080
      "slow_start"       = 100
    },
  ]

}