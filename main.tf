module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"
  bucket  = "data-lake-for-terraform-data-analysis"
}

module "redshift" {
  source  = "terraform-aws-modules/redshift/aws"
  version = "5.0.0"

  cluster_identifier = "terraform-data-analysis-redshift-cluster"
  node_type = "dc2.large"
  number_of_nodes = 1

  database_name          = var.database_name
  master_username        = var.master_username
  create_random_password = false
  master_password        = var.master_password  
}
