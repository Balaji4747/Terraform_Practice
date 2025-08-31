terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.11.0"
    }
  }

  backend "s3" {

    bucket = "my-terraform-bucket-47474747474747"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tws_junoon_state_table"
    
  }
}