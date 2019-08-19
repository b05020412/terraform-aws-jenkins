module "internal_alb" {
  source                    = "github.com/bsandeep23/terraform-aws-alb"
  load_balancer_is_internal = true
  load_balancer_name        = format("jenkins-internal-alb")
  security_groups           = concat(var.internal_alb_sg_list, var.jenkins_farm_sg_list)
  logging_enabled           = false
  subnets                   = var.subnets
  tags                      = var.common_tags
  vpc_id                    = var.vpc_id
  https_listeners           = local.https_listeners
  https_listeners_count     = local.https_listeners_count
  target_groups             = local.internal_target_groups
  target_groups_count       = local.target_groups_count
  //    extra_ssl_certs          = local.extra_ssl_certs
  //    extra_ssl_certs_count    = local.extra_ssl_certs_count
}


resource "aws_lb_target_group_attachment" "internal_jenkins" {
  count            = length(local.master_config)
  target_group_arn = module.internal_alb.target_group_arns[0]
  target_id        = aws_instance.master[count.index].id
  port             = 8080
}
