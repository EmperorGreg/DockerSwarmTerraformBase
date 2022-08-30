output "myIP" {
    value = aws_instance.myInstance.public_ip
}