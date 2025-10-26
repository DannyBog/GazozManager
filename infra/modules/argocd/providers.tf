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
