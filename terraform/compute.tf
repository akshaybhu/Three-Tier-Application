# ===================================
# MongoDB Instance
# ===================================
resource "aws_instance" "mongodb" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.mongodb_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "mongodb-instance"
  }

  user_data = templatefile("${path.module}/scripts/mongodb_setup.sh", {
    db_username = var.db_username
    db_password = var.db_password
    mongodb_port = var.mongodb_port
  })

  # Make sure security group is created before creating the instance
  depends_on = [aws_security_group.mongodb_sg]
}

# ===================================
# Backend Instance
# ===================================

resource "aws_instance" "backend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.backend_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "backend-instance"
  }

  user_data = templatefile("${path.module}/scripts/backend_setup.sh", {
    mongodb_ip = aws_instance.mongodb.private_ip
    mongodb_port = var.mongodb_port
    mongodb_username = var.db_username
    mongodb_password = var.db_password
    backend_port = var.backend_port
  })

  # Make sure MongoDB instance is created before creating the backend
  depends_on = [aws_instance.mongodb, aws_security_group.backend_sg]
}

# ===================================
# Frontend Instance
# ===================================

resource "aws_instance" "frontend" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.frontend_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "frontend-instance"
  }

  user_data = templatefile("${path.module}/scripts/frontend_setup.sh", {
    backend_ip = aws_instance.backend.public_ip
    backend_port = var.backend_port
    frontend_port = var.frontend_port
  })

  # Make sure Backend instance is created before creating the frontend
  depends_on = [aws_instance.backend, aws_security_group.frontend_sg]
}