resource "aws_vpc" "myVPC" {
    cidr_block="10.0.0.0/16"
    tags = {
        Name = "GeorgeVPC"
    }
}

resource "aws_internet_gateway" "myIG" {
    vpc_id = aws_vpc.myVPC.id
    tags = {
        Name = "GeorgeIG"
    }
}

resource "aws_subnet" "mySubnetPub" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-2b"
    map_public_ip_on_launch = true
    tags = {
        Name = "GeorgeSubnetPub"
    }
}

resource "aws_subnet" "mySubnetPR1" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-2a"
    tags = {
        Name = "GeorgeSubnetPR1"
    }
}

resource "aws_subnet" "mySubnetPR2" {
    vpc_id = aws_vpc.myVPC.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "eu-west-2b"
    tags = {
        Name = "GeorgeSubnetPR2"
    }

}

resource "aws_route_table" "myRT" {
    vpc_id = aws_vpc.myVPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myIG.id
    }
    tags = {
        Name = "GeorgeRT"
    }
}

resource "aws_route_table" "myPRRT" {
    vpc_id = aws_vpc.myVPC.id
    tags = {
        Name = "GeorgePRRT"
    }
}

resource "aws_db_subnet_group" "myDBgrp" {
    name = "mydbgrp"
    subnet_ids = [aws_subnet.mySubnetPR1.id, aws_subnet.mySubnetPR2.id]
}

resource "aws_route_table_association" "myRTAssoc" {
    subnet_id = aws_subnet.mySubnetPub.id
    route_table_id = aws_route_table.myRT.id
}

resource "aws_route_table_association" "myPRRTAssoc1"{
    subnet_id = aws_subnet.mySubnetPR1.id
    route_table_id = aws_route_table.myPRRT.id
}

resource "aws_route_table_association" "myPRRTAssoc2"{
    subnet_id = aws_subnet.mySubnetPR2.id
    route_table_id = aws_route_table.myPRRT.id
}

resource "aws_security_group" "mySG" {
    name = "app-mySG"
    description = "Allow http and https traffic"
    vpc_id = aws_vpc.myVPC.id
    ingress {
        description = "ssh port"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # port 22
    }
    ingress {
        description = "dev port"
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # port 5000
    }
    ingress {
        description = "HTTP port"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # port 80
    }
    ingress{
        description = "docker client communication"
        from_port   = 2376
        to_port     = 2376
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        description = "docker node communication"
        from_port   = 2377
        to_port     = 2377
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        description = "docker overlay network"
        from_port   = 4789
        to_port     = 4789
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        description = "docker inter node communication"
        from_port   = 7946
        to_port     = 7946
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress{
        description = "docker inter node communication"
        from_port   = 7946
        to_port     = 7946
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        to_port = 0
        from_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }


    tags = {
        Name = "GeorgeSG"
    }
}

resource "aws_security_group" "myDBSG"{
    name = "app-myDBSG"
    description = "allow SQL traffic"
    vpc_id = aws_vpc.myVPC.id
    ingress {
        description = "SQL traffic"
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.mySG.id]
    }
    egress {
        to_port = 0
        from_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "GeorgeDBSG"
    }

}