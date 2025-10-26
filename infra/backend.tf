# Configure Terraform to use an S3 backend for storing the state file
terraform {
	backend "s3" {
		bucket  = "danny-portfolio-bucket"
		key     = "terraform.tfstate"
		region  = "ap-south-1"
		encrypt = true
	}
}
