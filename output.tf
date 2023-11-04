output "alb_dns_name" {
  value = aws_lb.my_alb.dns_name
}

output "instance_ips" {
  value = aws_instance.ec2_instance[*].public_ip
}
