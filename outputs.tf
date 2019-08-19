output "master_public_ip" {
  description = "List of master public ips"
  value       = aws_instance.master.*.public_ip
}

output "master_private_ip" {
  description = "List of master private ips"
  value       = aws_instance.master.*.private_ip
}

output "master_instance_id" {
  description = "List of master instance id"
  value       = aws_instance.master.*.id
}

output "master_private_dns" {
  description = "List of master private dns"
  value       = aws_instance.master.*.private_dns
}


output "slave_public_ip" {
  description = "List of slave public ips"
  value       = aws_instance.slave.*.public_ip
}

output "slave_private_ip" {
  description = "List of slave private ips"
  value       = aws_instance.slave.*.private_ip
}

output "slave_instance_id" {
  description = "List of slave instance id"
  value       = aws_instance.slave.*.id
}

output "slave_private_dns" {
  description = "List of slave private dns"
  value       = aws_instance.slave.*.private_dns
}


output "alb_id" {
  value = module.alb.load_balancer_id
}

output "http_tcp_listener_arns" {
  value = module.alb.http_tcp_listener_arns
}

output "https_listener_arns" {
  value = module.alb.https_listener_arns
}

output "region" {
  value = var.region
}

output "target_group_arns" {
  value = module.alb.target_group_arns
}

output "target_groups_count" {
  value = local.target_groups_count
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "internal_alb_id" {
  value = module.internal_alb.load_balancer_id
}

output "internal_https_listener_arns" {
  value = module.internal_alb.https_listener_arns
}

output "internal_target_group_arns" {
  value = module.internal_alb.target_group_arns
}

output "internal_alb_dns_name" {
  value = module.internal_alb.dns_name
}
