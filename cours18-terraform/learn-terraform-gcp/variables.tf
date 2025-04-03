variable "project_id" {
  type        = string
  description = "Project id in GCP"
  # default     = "h25-4d4-24"
}

variable "region" {
  type        = string
  description = "Region where all elements are deployed in GCP"
  # default     = "us-east1"
}

variable "zone" {
  type        = string
  description = "Zone where all elements are deployed in GCP"
  # default     = "us-east1-b"
}

variable "mysql_user" {
  type        = string
  sensitive   = true
  description = "User of the MySQL DB in GCP"
  default     = "mael"
}

variable "mysql_password" {
  type        = string
  sensitive   = true
  description = "Password of the MySQL DB in GCP"
  default     = "pogo123456789"
}