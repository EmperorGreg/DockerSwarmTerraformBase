resource "aws_db_instance" "myDBInstance" {
    identifier = "mydb-a"
    allocated_storage = 10
    engine = "mysql"
    engine_version = "5.7"
    instance_class = "db.t2.micro"
    db_name = "mydb"
    username = "george"
    password = "password"
    port = 3306
    parameter_group_name = "default.mysql5.7"

    skip_final_snapshot = true
    iam_database_authentication_enabled = false
    vpc_security_group_ids = [var.DBSG]
    db_subnet_group_name = var.myDBgrp
}