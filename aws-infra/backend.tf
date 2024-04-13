terraform {
  backend "s3" {
    bucket         = "lds-01-terraform-backend"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = false
  }
}

# todo: add encryption
# question: can the backend s3 bucket can be created in the same terraform script?