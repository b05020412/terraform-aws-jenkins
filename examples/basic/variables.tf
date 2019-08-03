//  The region we will deploy our resources into.
variable "region" {
  description = "Region to deploy the cluster into"
  default     = "ap-northeast-1"
}

variable "owner" {
  description = "Owner of the infra"
  default     = "sre"
}

variable "component" {
  description = "Component name"
  default     = "devops"
}

variable "stack" {
  description = "Sub Component name"
  default     = "build"
}

variable "stage" {
  description = "stage "
  default     = "dev"
}

variable "key_name" {
  description = "devops ssh key name"
  default     = "devops_root_key"
}
