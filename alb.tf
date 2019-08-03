module "alb" {
    source  = "github.com/bsandeep23/terraform-aws-alb"

    load_balancer_name            = format("jenkins-alb")
    security_groups               = concat(var.alb_sg_list, var.jenkins_farm_sg_list)
    logging_enabled          = false
    subnets                  = var.subnets
    tags                     = var.common_tags
    vpc_id                   = var.vpc_id
    https_listeners          = local.https_listeners
    https_listeners_count    = local.https_listeners_count
    target_groups            = local.target_groups
    target_groups_count      = local.target_groups_count
//    extra_ssl_certs          = local.extra_ssl_certs
//    extra_ssl_certs_count    = local.extra_ssl_certs_count
}


resource "aws_lb_target_group_attachment" "jenkins" {
    count = length(local.master_config)
    target_group_arn = module.alb.target_group_arns[0]
    target_id = aws_instance.master[count.index].id
    port = 8080
}