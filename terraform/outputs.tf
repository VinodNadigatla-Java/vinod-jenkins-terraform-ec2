output "public_ip" {
  value = aws_instance.app.public_ip
}

output "url" {
  value = "http://${aws_instance.app.public_ip}"
}
