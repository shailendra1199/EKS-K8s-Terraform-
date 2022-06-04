#
# Provider Configuration
#
terraform {
  #   backend "remote" {
  #     organization = "ProvisonersTest"

  #     workspaces {
  #       name = "testporvisoner"
  #     }
  #   }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.15.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}



# Using these data sources allows the configuration to be
# generic for any region.
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}


provider "http" {}
