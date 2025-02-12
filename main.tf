terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }

    required_version = ">= 1.2.0"
}

provider "aws" {
    region = "us-west-2"
    profile = "default"
}

# Create S3 Bucket for Storing User Provided Data (CSV)
resource "aws_s3_bucket" "energy-monitoring-pdx" {
    bucket = "energy-monitoring-pdx"

    tags = {
        Name = "Household Energy Monitoring Data"
        Environment = "production"
    }
}

# Create Dynamo DB Table
resource "aws_dynamodb_table" "usr_energy_consumption" {
    name = "energyConsumption"
    billing_mode = "PAY_PER_REQUEST"

    # Primary Key
    attribute {
        name = "userId"
        type = "S"
    }

    attribute {
        name = "date"
        type = "S"
    }

    hash_key = "userId"
    sort_key = "date"

    # GSI Setup
    global_secondary_index {
        name = "dateIndex"
        hash_key = "date"
        range_key = "userId"
        projection_type = "ALL"
        write_capacity = 5
        read_capacity = 5
    }

    tags = {
        Name = "User Energy Consumption Table"
        Environment = "Production"
    }
}
