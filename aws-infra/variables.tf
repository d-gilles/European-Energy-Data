variable "AWS_ACCESS_KEY_ID" {
  type    = string
  default = "AKIAYS2NUNPN4B7JWOWF"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type    = string
  default = "jpVPxFyaTGgXsuUOmiirJd+c1Zxc/HuAFZOc/u2d"
}

variable "PROJECT_NAME" {
  type    = string
  default = "energy_data_etl"
}

variable "DATABASE_CONNECTION_URL" {
  type    = string
  default = ""
}

variable "bucket_name" {
  type = string
  default = "datalake-add-your-name" # Add your name here to have aunique bucket name
}

variable "app_count" {
  type    = number
  default = 1
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "eu-central-1"
}

variable "aws_cloudwatch_retention_in_days" {
  type        = number
  description = "AWS CloudWatch Logs Retention in Days"
  default     = 30
}

variable "app_name" {
  type        = string
  description = "Application Name"
  default     = "mageetl"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
  default     = "development"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.32.0.0/16"
}

variable "database_user" {
  type        = string
  description = "The username of the Postgres database."
  default     = "mageuser"
}

variable "database_password" {
  type        = string
  description = "The password of the Postgres database."
  sensitive   = true
  default     = "magepassword"
}

variable "docker_image" {
  description = "Docker image url used in ECS task."
  default     = "mageai/mageai:latest"
}

variable "ecs_task_cpu" {
  description = "ECS task cpu"
  default     = 512
}

variable "ecs_task_memory" {
  description = "ECS task memory"
  default     = 1024
}

variable "public_subnets" {
  description = "List of public subnets"
  default     = ["10.32.100.0/24", "10.32.101.0/24"]
}

variable "private_subnets" {
  description = "List of private subnets"
  default     = ["10.32.0.0/24", "10.32.1.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones"
  default     = ["eu-central-1a", "eu-central-1b"]
}

#####################################
## Redshift Serverless - Variables ##
#####################################

variable "redshift_serverless_namespace_name" {
  type        = string
  description = "Redshift Serverless Namespace Name"
}

variable "redshift_serverless_database_name" { 
  type        = string
  description = "Redshift Serverless Database Name"
}

variable "redshift_serverless_admin_username" {
  type        = string
  description = "Redshift Serverless Admin Username"
}

variable "redshift_serverless_admin_password" { 
  type        = string
  description = "Redshift Serverless Admin Password"
}

variable "redshift_serverless_workgroup_name" {
  type        = string
  description = "Redshift Serverless Workgroup Name"
}

variable "redshift_serverless_base_capacity" {
  type        = number
  description = "Redshift Serverless Base Capacity"
  default     = 32 // 32 RPUs to 512 RPUs in units of 8 (32,40,48...512)
}

variable "redshift_serverless_publicly_accessible" {
  type        = bool
  description = "Set the Redshift Serverless to be Publicly Accessible"
  default     = false
}