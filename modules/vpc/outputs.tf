output "mySG" {
    value = aws_security_group.mySG.id
}

output "myDBSG" {
    value = aws_security_group.myDBSG.id
}

output "myDBgrp" {
    value = aws_db_subnet_group.myDBgrp.id
}

output "mySubnetPub" {
    value = aws_subnet.mySubnetPub.id
}