terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = ">= 2.11"
  region  = var.region
}

provider "local" {
  version = "~> 1.2"
}


data "aws_availability_zones" "available" {
}

locals {
  vpc_id                  = "vpc-0c56d28b0cef4eb29"
  sg_devteams_id          = "sg-0c825b07214fadee6"
  sg_smd_admin_cluster_id = "sg-0036e1500a9a17dfe"
  default_sg_id           = "sg-027e01aaa3fed097f"
  public_subnets = [
    "subnet-073d9f33b8f040873",
  "subnet-018872f47e870d01e",
  "subnet-0974089ffcb6883d2",
  ]

  keypair_name = "devops_root_key"
  name_prefix  = format("%s-%s-%s-%s", var.component, var.stack, var.stage, var.region)
  cert_arn     = "arn:aws:acm:ap-northeast-1:149599074833:certificate/65eecb45-fb0d-4db9-b6b0-db5f9b23466e"

  common_tags = {
    Owner     = var.owner
    Component = var.component
    Stack     = var.stack
    Stage     = var.stage
    Creator   = "terraform"
  }
}

module "jenkins" {
  source = "../../"

  region      = var.region
  component   = var.component
  stack       = var.stack
  stage       = var.stage
  name_prefix = local.name_prefix
  common_tags = local.common_tags

  vpc_id = local.vpc_id

  subnets      = local.public_subnets
  keypair_name = local.keypair_name
  create_alb   = true
  cert_arn     = local.cert_arn

  jenkins_farm_sg_list     = [local.default_sg_id]
  master_sg_list           = [local.sg_devteams_id]
  slave_sg_list            = [local.sg_smd_admin_cluster_id]
  alb_sg_list              = [local.sg_devteams_id]
  default_master_subnet_id = local.public_subnets[2]
  default_master_ami       = data.aws_ami.amazonlinux.id

  default_slave_subnet_id = local.public_subnets[2]
  default_slave_ami       = data.aws_ami.amazonlinux.id

  master_config = [
    {
      instance_family    = "t2.small"
      root_ebs_size      = "25"
      additional_sg_list = [local.sg_smd_admin_cluster_id]
      ami                = data.aws_ami.rhel7_5.id
      subnet_id          = local.public_subnets[1]
    },
    {

    },
  ]

  slave_config = [
    {
      subnet_id          = local.public_subnets[0]
    },
    {
      additional_sg_list = [local.sg_devteams_id, local.sg_smd_admin_cluster_id, local.default_sg_id]
      subnet_id          = local.public_subnets[1]
      keypair_name       = "devops_jumphost"
    },

  ]
}

