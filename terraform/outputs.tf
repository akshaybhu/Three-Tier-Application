output "mongodb_private_ip" {
  value       = aws_instance.mongodb.private_ip
  description = "The private IP address of the MongoDB instance"
}

output "backend_public_ip" {
  value       = aws_instance.backend.public_ip
  description = "The public IP address of the Backend instance"
}

output "backend_private_ip" {
  value       = aws_instance.backend.private_ip
  description = "The private IP address of the Backend instance"
}

output "frontend_public_ip" {
  value       = aws_instance.frontend.public_ip
  description = "The public IP address of the Frontend instance"
}

output "application_url" {
  value       = "http://${aws_instance.frontend.public_ip}"
  description = "URL to access the application"
}