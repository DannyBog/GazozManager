# Fetch the secret data from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "portfolio_secrets" {
	secret_id = "danny-portfolio-secrets"
}

# Fetch the SSH key from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "argocd_ssh_key" {
	secret_id = var.ssh_key_secret_id
}

locals {
	secrets_json = jsondecode(data.aws_secretsmanager_secret_version.portfolio_secrets.secret_string)
}

resource "kubernetes_secret" "portfolio_secrets_app" {
	metadata {
		name      = "danny-portfolio-secrets"
		namespace = var.app_namespace
	}
	
	data = {
		"mongodb-passwords"       = local.secrets_json["mongodb-passwords"]
		"mongodb-root-password"   = local.secrets_json["mongodb-root-password"]
		"mongodb-replica-set-key" = local.secrets_json["mongodb-replica-set-key"]
	}

	type       = "Opaque"
	depends_on = [kubernetes_namespace.app]
}

resource "kubernetes_secret" "portfolio_secrets_logging" {
	metadata {
		name      = "danny-portfolio-secrets"
		namespace = "logging"
	}

	type       = "Opaque"
	depends_on = [kubernetes_namespace.logging]
}

resource "kubernetes_secret" "portfolio_secrets_monitoring" {
	metadata {
		name      = "danny-portfolio-secrets"
		namespace = "monitoring"
	}

	data = {
		"grafana-username" = local.secrets_json["grafana-username"]
		"grafana-password" = local.secrets_json["grafana-password"]
	}

	type       = "Opaque"
	depends_on = [kubernetes_namespace.monitoring]
}

resource "kubernetes_secret" "argocd_repo_creds" {
	metadata {
		name      = var.repo_creds_name
		namespace = var.argocd_namespace

		labels = {
			"argocd.argoproj.io/secret-type" = "repository"
		}
	}

	data = {
		name          = var.repo_creds_repo_name
		type          = var.repo_creds_type
		project       = var.repo_creds_project
		url           = var.repo_url
		sshPrivateKey = data.aws_secretsmanager_secret_version.argocd_ssh_key.secret_string
	}
}
