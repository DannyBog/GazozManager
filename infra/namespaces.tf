resource "kubernetes_namespace" "app" {
	metadata {
		name = var.app_namespace
	}
}

resource "kubernetes_namespace" "logging" {
	metadata {
		name = "logging"
	}
}

resource "kubernetes_namespace" "monitoring" {
	metadata {
		name = "monitoring"
	}
}
