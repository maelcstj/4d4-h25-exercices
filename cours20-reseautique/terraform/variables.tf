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

variable "mysql_user" {
  type        = string
  description = "MySQL user name"
}

variable "mysql_password" {
  type        = string
  description = "MySQL user password"
}

variable "mysql_database" {
  type        = string
  description = "MySQL database"
}

