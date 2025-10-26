variable "project_name" {
	type = string
}

variable "vpc_cidr" {
	type = string
}

variable "cluster_name" {
	type = string
}

variable "tags" {
	type = map(string)
}

variable "expiration_date" {
	description = "The expiration date to use for resources"
	type        = string
}
