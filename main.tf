module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"
  bucket  = "data-lake-for-terraform-data-analysis"
}



