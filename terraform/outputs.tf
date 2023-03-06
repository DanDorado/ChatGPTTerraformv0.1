output "app_base_url" {
  value = "http://${aws_instance.app_instance.public_ip}:5000/"
}