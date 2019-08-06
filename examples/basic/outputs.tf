output "master_public_ip" {
    description = "List of master public ips"
    value = module.jenkins.master_public_ip
}

output "master_private_ip" {
    description = "List of master private ips"
    value = module.jenkins.master_private_ip
}

output "master_instance_id" {
    description = "List of master instance id"
    value = module.jenkins.master_instance_id
}

output "master_private_dns" {
    description = "List of master private dns"
    value = module.jenkins.master_private_dns
}


output "slave_public_ip" {
    description = "List of slave public ips"
    value = module.jenkins.slave_public_ip
}

output "slave_private_ip" {
    description = "List of slave private ips"
    value = module.jenkins.slave_private_ip
}

output "slave_instance_id" {
    description = "List of slave instance id"
    value = module.jenkins.slave_instance_id
}

output "slave_private_dns" {
    description = "List of slave private dns"
    value = module.jenkins.slave_private_dns
}

output "alb_id" {
  value = module.jenkins.alb_id
}

output "http_tcp_listener_arns" {
  value = module.jenkins.http_tcp_listener_arns
}

output "https_listener_arns" {
  value = module.jenkins.https_listener_arns
}

output "region" {
  value = var.region
}

output "target_group_arns" {
  value = module.jenkins.target_group_arns
}

output "target_groups_count" {
  value = module.jenkins.target_groups_count
}

output "alb_dns_name" {
    value = module.jenkins.alb_dns_name
}
