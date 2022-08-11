terraform {
  cloud {
    organization = "alexandre3gomes"
    workspaces {
      name = "finances"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.25.0"
    }
  }
  required_version = ">= 1.2.0"
}

variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "AWS access key used by terraform"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "AWS secret access key used by terraform"
}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"
}