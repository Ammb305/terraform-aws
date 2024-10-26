module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    subnet_cidr = var.subnet_cidr
}
module "TerraformSG" {
    source = "./modules/sg"
    vpc_id = module.vpc.vpc_id
}
module "TerraformEC2" {
    source = "./modules/ec2"
    sg_id = module.TerraformSG.sg_id
    subnets = module.vpc.subnet_ids
}
module "TerraformALB" {
    source = "./modules/alb"
    sg_id = module.TerraformSG.sg_id
    subnets = module.vpc.subnet_ids
    vpc_id = module.vpc.vpc_id
    instances = module.TerraformEC2.instances
}
