output "instances" {
  value = aws_instance.TerraformEC2[*].id
}