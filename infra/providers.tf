provider "aws" {
	region = var.region

	default_tags {
		tags = var.tags
	}
}

terraform {
	required_providers {
		kubectl = {
			source  = "gavinbunney/kubectl"
			version = "1.19.0"
		}
		
		aws = {
			source  = "hashicorp/aws"
			version = "6.5.0"
		}
		
		kubernetes = {
			source  = "hashicorp/kubernetes"
			version = "2.38.0"
		}
		
		helm = {
			source  = "hashicorp/helm"
			version = "3.0.2"
		}
	}
}

provider "kubernetes" {
	host                   = module.compute.cluster_endpoint
	cluster_ca_certificate = base64decode(module.compute.cluster_certificate_authority_data)
	token                  = module.compute.cluster_token
}

provider "kubectl" {
	host                   = module.compute.cluster_endpoint
	cluster_ca_certificate = base64decode(module.compute.cluster_certificate_authority_data)
	token                  = module.compute.cluster_token
	load_config_file       = false
}

provider "helm" {
	kubernetes = {
		host                   = module.compute.cluster_endpoint
		cluster_ca_certificate = base64decode(module.compute.cluster_certificate_authority_data)
		token                  = module.compute.cluster_token
	}
}
