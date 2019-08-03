data "template_file" "setup-slave" {
  count    = length(local.slave_config)
  template = file(format("%s/files/setup-slave.sh", path.module))

  vars = {
    hostname = format("jenkins-slave-%d", count.index + 1)
  }

}
resource "aws_instance" "slave" {
  count = length(local.slave_config)

  ami           = local.slave_config[count.index].ami
  instance_type = local.slave_config[count.index].instance_family

  user_data = data.template_file.setup-slave[count.index].rendered
  key_name = local.slave_config[count.index].keypair_name

  subnet_id              = local.slave_config[count.index].subnet_id
  vpc_security_group_ids = concat(var.jenkins_farm_sg_list, var.slave_sg_list, local.slave_config[count.index].additional_sg_list)

  root_block_device {
    volume_size = local.slave_config[count.index].root_ebs_size
    volume_type = local.slave_config[count.index].root_volume_type
  }

  tags = merge(var.common_tags, {
    Name = format("%s-jenkins-slave-%d-instance", var.name_prefix, count.index + 1)
  })

  volume_tags = merge(var.common_tags, {
    Name = format("%s-jenkins-slave-%d-ebs", var.name_prefix, count.index + 1)
  })

}