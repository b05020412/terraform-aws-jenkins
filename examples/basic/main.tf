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
  vpc_id                  = "vpc-12345678"
  sg_dev_id          = "sg-12345678"
  default_sg_id           = "sg-12345678"
  public_subnets = [
    "subnet-12345678",
  "subnet-12345678",
  "subnet-12345678",
  ]

  private_subnets = [
    "subnet-12345678",
  "subnet-12345678",
  "subnet-12345678",
  ]

  keypair_name = "key"
  name_prefix  = format("%s-%s-%s-%s", var.component, var.stack, var.stage, var.region)
  cert_arn     = "arn:aws:acm:ap-northeast-1:123456789:certificate/65eecb45-fb0d-4db9-b6b0-db5f9b23466e"

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
  cert_arn     = local.cert_arn
  devops_user_public_key = "sshpublickey"

  jenkins_farm_sg_list     = [local.default_sg_id]
  master_sg_list           = [local.sg_dev_id]
  slave_sg_list            = []
  alb_sg_list              = [local.sg_dev_id]
  default_master_subnet_id = local.public_subnets[2]
  default_master_ami       = data.aws_ami.amazonlinux.id

  default_slave_subnet_id = local.public_subnets[2]
  default_slave_ami       = data.aws_ami.amazonlinux.id

  master_config = [
    {
      instance_family    = "t2.small"
      root_ebs_size      = "25"
      additional_sg_list = []
      ami                = data.aws_ami.rhel7_5.id
      subnet_id          = local.public_subnets[1]
    },
    {

    },
  ]

  slave_config = [
    {
      subnet_id          = local.private_subnets[0]
    },
    {
      additional_sg_list = [local.sg_devteams_id, local.default_sg_id]
      subnet_id          = local.private_subnets[1]
      keypair_name       = "jumphost"
    },

  ]
}

