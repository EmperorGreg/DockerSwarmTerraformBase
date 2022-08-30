resource "aws_instance" "myInstance" {
    ami           = "ami-0bd2099338bc55e6d" # ami_no, region bound
    instance_type = "t2.micro"
    key_name = var.KeyName
    subnet_id = var.subnetPub
    vpc_security_group_ids = [var.mySG] # security group id number (resource_type.resource_name.id)
    private_ip = "10.0.1.10"
    associate_public_ip_address = true

    #user_data = <<-EOL
    #!/bin/bash
    #sudo apt update
    #sudo echo "USERNAME=${var.username}" >> /etc/environment
    #sudo echo "PASSWORD=${var.password}" >> /etc/environment
    #sudo echo "NAME=${var.dbname}" >> /etc/environment
    #sudo echo "ENDPOINT=${var.endpoint}" >> /etc/environment
    #sudo apt install mysql-server -y
    #EOL
    
    #depends_on = [
    #    aws_db_instance.myDBInstance
    #]
}