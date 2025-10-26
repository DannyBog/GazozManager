# Module for creating argoCD and related resources
module "argocd" {
	source                = "./modules/argocd"
	argocd_namespace      = var.argocd_namespace
	argocd_release_name   = var.argocd_release_name
	argocd_repository     = var.argocd_repository
	argocd_chart          = var.argocd_chart
	argocd_version        = var.argocd_version
	ssh_key_secret_id     = var.ssh_key_secret_id
	repo_creds_name       = var.repo_creds_name
	repo_creds_repo_name  = var.repo_creds_repo_name
	repo_creds_type       = var.repo_creds_type
	repo_creds_project    = var.repo_creds_project
	repo_url              = var.repo_url
	app_namespace         = var.app_namespace
	infra_apps_namespace  = var.infra_apps_namespace
	app_path              = var.app_path
	infra_apps_path       = var.infra_apps_path
	secrets_json          = local.secrets_json
	region                = var.region
	account_id            = var.account_id
}

# Module for creating the VPC and related resources
module "network" {
	source          = "./modules/network"
	vpc_cidr        = var.vpc_cidr
	cluster_name    = var.cluster_name
	project_name    = var.project_name
	tags            = var.tags
	expiration_date = formatdate("DD-MM-YY", timestamp())
}

# Module for creating the EKS cluster and node group
module "compute" {
	source             = "./modules/compute"
	cluster_name       = var.cluster_name
	private_subnet_ids = module.network.private_subnet_ids
	instance_type      = var.instance_type
	scaling_desired    = var.scaling_desired
	scaling_min        = var.scaling_min
	scaling_max        = var.scaling_max
	vpc_id             = module.network.vpc_id
	region             = var.region
	project_name       = var.project_name
	disk_size          = var.disk_size
	capacity_type      = var.capacity_type
	max_unavailable    = var.max_unavailable
	tags               = var.tags
	expiration_date    = formatdate("DD-MM-YY", timestamp())
}
