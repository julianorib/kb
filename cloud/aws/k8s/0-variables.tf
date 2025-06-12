variable "project_name" {}
variable "region" {}
variable "user" {}
variable "tag-ambiente" {}
variable "k8s_version" {
  type        = string
  description = "Versao do Kubernetes"
  default     = "1.32"
}