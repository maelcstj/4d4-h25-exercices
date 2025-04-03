variable "project_id" {
  type        = string
  description = "Project id to use for the whole deployment"
}

variable "region" {
  type        = string
  description = "Region to deploy GKE cluster and other resources"
}

variable "zone" {
  type        = string
  description = "Zone to deploy GKE cluster and other resources"
}