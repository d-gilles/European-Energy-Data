resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "my-redshift-subnet-group"
  subnet_ids = aws_subnet.public[*].id

  tags = {
    Name = "My Redshift Subnet Group"
  }
}

resource "aws_security_group" "redshift_sg" {
  name        = "${var.app_name}-redshift-sg"
  description = "Security group for Redshift cluster allowing all incoming traffic from public subnets"
  vpc_id      = aws_vpc.aws-vpc.id  

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [aws_security_group.service_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.app_name}-redshift-sg"
    Environment = var.app_environment
  }
}

resource "aws_redshift_cluster" "dwh" {
  cluster_identifier = var.cluster_identifier
  database_name      = var.database_name
  master_username    = var.db_master_user
  master_password    = var.db_master_pwd
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
  vpc_security_group_ids   = [aws_security_group.redshift_sg.id]
  iam_roles          = [aws_iam_role.redshift_s3_access_role.arn]  
}


resource "aws_iam_role" "redshift_s3_access_role" {
  name = "${var.app_name}-redshift-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "redshift.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name        = "${var.app_name}-redshift-s3-role"
    Environment = var.app_environment
  }
}

resource "aws_iam_policy" "redshift_s3_policy" {
  name        = "${var.app_name}-redshift-s3-policy"
  description = "Policy that allows Redshift instances to access S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::your-bucket-name",
          "arn:aws:s3:::your-bucket-name/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "redshift_s3_policy_attachment" {
  role       = aws_iam_role.redshift_s3_access_role.name
  policy_arn = aws_iam_policy.redshift_s3_policy.arn
}
