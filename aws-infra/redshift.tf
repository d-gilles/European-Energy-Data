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
}

output "redshift_endpoint" {
  value = aws_redshift_cluster.dwh.endpoint
}