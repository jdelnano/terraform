output "lb_sg_id" {
  value = aws_security_group.lb.id
}

output "target_group_arn" {
  value = aws_lb_target_group.http.arn
}
