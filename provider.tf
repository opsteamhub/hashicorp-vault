terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }
  }
}

provider "aws" {
  region = local.region_principal
}

provider "aws" {
  alias  = "replica"
  region = var.create_replica == "true" ? local.region_replica : local.region_principal
}

