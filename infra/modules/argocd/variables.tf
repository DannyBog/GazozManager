variable "argocd_namespace" {
	type = string
}

variable "argocd_release_name" {
	type = string
}

variable "argocd_repository" {
	type = string
}

variable "argocd_chart" {
	type = string
}

variable "argocd_version" {
	type = string
}

variable "ssh_key_secret_id" {
	type = string
}

variable "repo_creds_name" {
	type = string
}

variable "repo_creds_repo_name" {
	type = string
}

variable "repo_creds_type" {
	type = string
}

variable "repo_creds_project" {
	type = string
}

variable "repo_url" {
	type = string
}

variable "app_namespace" {
	type = string
}

variable "infra_apps_namespace" {
	type = string
}

variable "app_path" {
	type = string
}

variable "infra_apps_path" {
	type = string
}

variable "secrets_json" {
	type = map(string)
}

variable "region" {
	type = string
}

variable "account_id" {
	type = string
}
