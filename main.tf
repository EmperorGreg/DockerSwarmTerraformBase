provider "aws" {
  region = "eu-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module vpc {
    source = "./modules/vpc/"
}
module db {
    source = "./modules/db"
    myDBgrp  = module.vpc.myDBgrp
    DBSG = module.vpc.myDBSG
}
module webserver {
    source = "./modules/webserver"
    subnetPub = module.vpc.mySubnetPub
    mySG = module.vpc.mySG
    #public_ip = module. # public_ip to db_server_name is part of the EXTENSION/STRETCH EXERCISE
    #endpoint = module.db.endpoint
    #username = module.db.username
    #password = module.db.password
    #dbname = module.db.db_name
    #db_server_name = module.db.db_server_name
}
module webserver2 {
    source = "./modules/webserver2"
    subnetPub = module.vpc.mySubnetPub
    mySG = module.vpc.mySG
    #public_ip = module. # public_ip to db_server_name is part of the EXTENSION/STRETCH EXERCISE
    #endpoint = module.db.endpoint
    #username = module.db.username
    #password = module.db.password
    #dbname = module.db.db_name
    #db_server_name = module.db.db_server_name
}



