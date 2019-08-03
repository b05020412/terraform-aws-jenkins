data "template_file" "setup-master" {
  count    = length(local.master_config)
  template = file(format("%s/files/setup-master.sh", path.module))

  vars = {
    hostname = format("jenkins-master-%d", count.index + 1)
  }

}
resource "aws_instance" "master" {
  count = length(local.master_config)

  ami           = local.master_config[count.index].ami
  instance_type = local.master_config[count.index].instance_family

  user_data = data.template_file.setup-master[count.index].rendered
  key_name = local.master_config[count.index].keypair_name

  subnet_id              = local.master_config[count.index].subnet_id
  vpc_security_group_ids = concat(var.jenkins_farm_sg_list, var.master_sg_list, local.master_config[count.index].additional_sg_list)

  root_block_device {
    volume_size = local.master_config[count.index].root_ebs_size
    volume_type = local.master_config[count.index].root_volume_type
  }

  tags = merge(var.common_tags, {
    Name = format("%s-jenkins-master-%d-instance", var.name_prefix, count.index + 1)
  })

  volume_tags = merge(var.common_tags, {
    Name = format("%s-jenkins-master-%d-ebs", var.name_prefix, count.index + 1)
  })

}