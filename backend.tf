provider "aws" {
    region = "us-east-1"
}

terraform {
    backend "s3" {
        bucket = "terraform-state-anima"
        key    = "state/cluster-vault-opsteam.tfstate"
        region = "us-east-1"
    }
}