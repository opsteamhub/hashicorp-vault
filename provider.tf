terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "~> 4.15.1"
      version = ">= 4.60.0"
    }
  }
}

provider "aws" {
  region = var.region_principal
}

provider "aws" {
  alias  = "replica"
  region = var.create_replica == true ? var.region_replica : var.region_principal

}
