output "wordpress_public_ip" {
  description = "Public IP address of the WordPress instance"
  value       = aws_instance.wordpress_instance.public_ip
}

output "wordpress_url" {
  description = "URL to access WordPress"
  value       = "http://${aws_instance.wordpress_instance.public_ip}"
}