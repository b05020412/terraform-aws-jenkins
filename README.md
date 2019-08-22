# terraform-aws-jenkins

A terraform module to provision a Jenkins build farm on AWS

## Assumptions

* You want to create internl and external load balancers for jenkins with https listeners
* You want these resources to exist within security groups that allow communication and coordination. 
* You've created a Virtual Private Cloud (VPC) and subnets where you intend to put the Jenkins resources.
* Jenkins master and slaves will be created in private subnets. Ensure private subnets are attached with a nat gateway.


## Usage example

A full example leveraging other community modules is contained in the [examples/basic directory](https://github.com/bsandeep23/terraform-aws-jenkins/tree/master/examples/basic). Here's the gist of using it via the Terraform registry:

```hcl
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
  cert_arn     = "arn:aws:acm:ap-northeast-1:123456789:certificate/abcdef-fb0d-4db9-b6b0-db5f9b23466e"

  common_tags = {
    Owner     = var.owner
    Component = var.component
    Stack     = var.stack
    Stage     = var.stage
    Creator   = "terraform"
  }
}

module "jenkins" {
  source = "github.com/bsandeep23/terraform-aws-jenkins"

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
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb\_sg\_list | list of security groups to be attached to the alb | list | `<list>` | no |
| cert\_arn | aws acm arn of the domain | string | n/a | yes |
| common\_tags | Common tags to be added on every resource | map | n/a | yes |
| component | Component for which the jenkins is being created. for eg: devops | string | n/a | yes |
| default\_master\_ami | Default master ami. This value will be used if master ami is not provided | string | n/a | yes |
| default\_master\_instance\_family | Default master instance family. This value will be used if master instance family is not provided | string | `"t2.medium"` | no |
| default\_master\_root\_ebs\_size | Default master root ebs size. This value will be used if master root ebs size is not provided | string | `"50"` | no |
| default\_master\_root\_volume\_type | Default master root volume type. This value will be used if master root volume type is not given | string | `"gp2"` | no |
| default\_master\_subnet\_id | Default master subnet id | string | n/a | yes |
| default\_slave\_ami | Default slave ami. This value will be used if slave ami is not provided | string | n/a | yes |
| default\_slave\_instance\_family | Default slave instance family. This value will be used if slave instance family is not provided | string | `"t2.medium"` | no |
| default\_slave\_root\_ebs\_size | Default slave root ebs size. This value will be used if slave root ebs size is not provided | string | `"50"` | no |
| default\_slave\_root\_volume\_type | Default slave root volume type. This value will be used if slave root volume type is not given | string | `"gp2"` | no |
| default\_slave\_subnet\_id | Default slave subnet id | string | n/a | yes |
| devops\_user\_public\_key | Devops user public key | string | n/a | yes |
| internal\_alb\_sg\_list | list of security groups to be attached to the internal alb | list | `<list>` | no |
| jenkins\_farm\_sg\_list | list of default security groups to be attached to all the resources in jenkins farm | list | `<list>` | no |
| keypair\_name | Key pair to be used for launching the instances | string | n/a | yes |
| master\_config | List of Maps containing the configuration of master instance | string | n/a | yes |
| master\_sg\_list | list of default security groups to be attached to the master instance | list | `<list>` | no |
| name\_prefix | naming prefix for all resources. for eg: tf-devops-jenkins-dev-ap-northeast-1- | string | n/a | yes |
| private\_subnets | list of private subnets in which the instances can be launched | list | n/a | yes |
| region | region in which it is being deployed | string | n/a | yes |
| slave\_config | List of map containg the configuration of slave instances | string | n/a | yes |
| slave\_sg\_list | list of default security groups to be attached to the jenkins slave instances | list | `<list>` | no |
| stack | Stack . for eg: jenkins | string | n/a | yes |
| stage | Stage for eg: dev, stg | string | n/a | yes |
| subnets | list of subnets in which the instances can be launched | list | n/a | yes |
| vpc\_id | vpc id in which the build farm has to be created | string | n/a | yes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
