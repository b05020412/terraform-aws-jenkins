variable "region" {
  description = "region in which it is being deployed"
  type        = string
}

variable "component" {
  description = "Component for which the eks is being created. for eg: devops"
  type        = string
}

variable "stack" {
  description = "Stack . for eg: network"
  type        = string
}

variable "stage" {
  description = "Stage for eg: dev, stg"
  type        = string
}

variable "name_prefix" {
  description = "naming prefix for all resources. for eg: tf-devops-build-dev-ap-northeast-1-"
  type        = string
}

variable "common_tags" {
  description = "Common tags to be added on every resource"
  type        = map(string)
}


variable "vpc_id" {
  description = "vpc id in which the build farm has to be created"
  type        = string
}

variable "subnets" {
  description = "list of subnets in which the instances can be launched"
  type        = list(string)
}

variable "keypair_name" {
  description = "Key pair to be used for launching the instances"
  type        = string
}

variable "create_alb" {
  description = "True if alb has to be created"
  type        = bool
  default     = true
}

variable "master_create_eip" {
  description = "True if eip has to created for jenkins master"
  type        = bool
  default     = false
}

variable "cert_arn" {
  description = "aws acm arn of the domain"
}

variable "jenkins_farm_sg_list" {
  description = "list of default security groups to be attached to all the resources in jenkins farm"
  type        = list(string)
  default     = []
}

variable "master_sg_list" {
  description = "list of default security groups to be attached to the master instance"
  type        = list(string)
  default     = []
}

variable "slave_sg_list" {
  description = "list of default security groups to be attached to the jenkins slave instances"
  type        = list(string)
  default     = []
}

variable "alb_sg_list" {
  description = "list of security groups to be attached to the alb"
  type        = list(string)
  default     = []
}

variable "master_config" {
  description = "List of Maps containing the configuration of master instance"
  //  type        = list(map(any))
  //  default     = []
}

variable "slave_config" {
  description = "List of map containg the configuration of slave instances"
  //  type        = list(map(any))
  //  default     = []
}

variable "default_master_instance_family" {
  description = "Default master instance family. This value will be used if master instance family is not provided"
  type        = string
  default     = "t2.medium"
}

variable "default_master_root_ebs_size" {
  description = "Default master root ebs size. This value will be used if master root ebs size is not provided"
  type        = string
  default     = "50"
}

variable "default_master_root_volume_type" {
  description = "Default master root volume type. This value will be used if master root volume type is not given"
  type        = string
  default     = "gp2"
}

variable "default_master_ami" {
  description = "Default master ami. This value will be used if master ami is not provided"
  type        = string
}

variable "default_master_subnet_id" {
  description = "Default master subnet id"
  type        = string
}

variable "default_slave_instance_family" {
  description = "Default slave instance family. This value will be used if slave instance family is not provided"
  type        = string
  default     = "t2.medium"
}

variable "default_slave_root_ebs_size" {
  description = "Default slave root ebs size. This value will be used if slave root ebs size is not provided"
  type        = string
  default     = "50"
}

variable "default_slave_root_volume_type" {
  description = "Default slave root volume type. This value will be used if slave root volume type is not given"
  type        = string
  default     = "gp2"
}

variable "default_slave_ami" {
  description = "Default slave ami. This value will be used if slave ami is not provided"
  type        = string
}

variable "default_slave_subnet_id" {
  description = "Default slave subnet id"
  type        = string
}

variable "devops_user_public_key" {
  description = "Devops user public key"
  type        = string
}

variable "internal_alb_sg_list" {
  description = "list of security groups to be attached to the internal alb"
  type        = list(string)
  default     = []
}

variable "jenkins_jnlp_port" {
  description = "Jenkins jnlp port"
  type        = string
  default     = 50000
}
