
resource "aws_instance" "public-instance" {
  ami                         = "ami-0532be01f26a3de55"
  instance_type               = var.INSTANCE_TYPE
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = var.IF_PUBLIC_IP
  tags = {
    Name = "public-instance"
  }
}

output "public-instance-ip" {
  value = aws_instance.public-instance.public_ip
}

