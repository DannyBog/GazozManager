variable "region" {
	type = string
}

variable "project_name" {
	type = string
}

variable "vpc_id" {
	type = string
}

variable "private_subnet_ids" {
	type = list(string)
}

variable "cluster_name" {
	type = string
}

variable "instance_type" {
	type = string
}

variable "disk_size" {
	type = number
}

variable "capacity_type" {
	type = string
}

variable "scaling_desired" {
	type = number
}

variable "scaling_min" {
	type = number
}

variable "scaling_max" {
	type = number
}

variable "max_unavailable" {
	type = number
}

variable "tags" {
	type = map(string)
}

variable "expiration_date" {
	description = "The expiration date to use for resources"
	type        = string
}
