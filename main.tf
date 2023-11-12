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

resource "aws_iam_role" "redshift_s3_access_role" {
  name = "RedshiftS3AccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "redshift.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy" "redshift_s3_access_policy" {
  name = "RedshiftS3AccessPolicy"
  role = aws_iam_role.redshift_s3_access_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect = "Allow",
        Resource = [
          module.s3-bucket.s3_bucket_arn,
          "${module.s3-bucket.s3_bucket_arn}/*" 
        ],
      },
    ],
  })
}

module "script-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"
  bucket  = "script-bucket-for-terraform-data-analysis"
}