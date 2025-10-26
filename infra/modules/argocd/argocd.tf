# ArgoCD Resources
#  * Kubernetes Namespace for ArgoCD
#  * Helm Release for ArgoCD
#  * Kubectl manifest for weather app ArgoCD application
#  * Kubectl manifest for infra apps ArgoCD application

resource "kubernetes_namespace" "argocd" {
	metadata {
		name = var.argocd_namespace
	}
}

# Deploy ArgoCD using Helm
resource "helm_release" "argocd" {
	name       = "argocd"
	namespace  = var.argocd_namespace
	repository = var.argocd_repository
	chart      = var.argocd_chart
	version    = var.argocd_version

	set = [{
		name  = "server.service.type"
		value = "ClusterIP"
	}]

	set_sensitive = [{
		name  = "configs.secret.argocdServerAdminPassword"
		value = bcrypt(var.secrets_json["argocd-password"])
	}]

	depends_on = [kubernetes_namespace.argocd]
}

# First ArgoCD App using kubectl manifest for the gazoz app
resource "kubectl_manifest" "argocd_application_gazoz" {
	yaml_body = templatefile("${path.module}/templates/app.yaml.tpl", {
		namespace     = var.argocd_namespace
		repo_url      = var.repo_url
		app_namespace = var.app_namespace
		app_path      = var.app_path
	})

	depends_on = [helm_release.argocd]
}

# Second ArgoCD App using kubectl manifest for the infra apps
resource "kubectl_manifest" "argocd_application_infra" {
	yaml_body = templatefile("${path.module}/templates/infra_apps.yaml.tpl", {
		namespace       = var.argocd_namespace
		repo_url        = var.repo_url
		infra_namespace = var.infra_apps_namespace
		infra_path      = var.infra_apps_path
	})

	depends_on = [helm_release.argocd]
}
