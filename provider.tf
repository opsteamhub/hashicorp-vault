provider "aws" {
  region = local.region_principal
}

provider "aws" {
  alias  = "replica"
  region = local.region_replica
}

