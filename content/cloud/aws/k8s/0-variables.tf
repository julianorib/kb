variable "project_name" {}
variable "region" {}
variable "user" {}
variable "tag-ambiente" {
  type        = string
  description = "Ambiente do Projeto"
  default     = "test"
}
variable "k8s_version" {
  type        = string
  description = "Versao do Kubernetes"
  default     = "1.33"
}
variable "eks_public_access" {
  type        = bool
  description = "Acesso publico ao EKS"
  default     = false
}
variable "eks_instance_types" {
  type        = list(any)
  description = "EKS Node Instance"
  default     = ["t3.medium"]
}
variable "eks_ondemand_desired" {
  type        = number
  description = "EKS Node Desired"
  default     = 2
}
variable "eks_ondemand_max" {
  type        = number
  description = "EKS Node Max"
  default     = 3
}
variable "eks_ondemand_min" {
  type        = number
  description = "EKS Node Min"
  default     = 1
}

variable "eks_spot_desired" {
  type        = number
  description = "EKS Node Desired"
  default     = 2
}
variable "eks_spot_max" {
  type        = number
  description = "EKS Node Max"
  default     = 3
}
variable "eks_spot_min" {
  type        = number
  description = "EKS Node Min"
  default     = 1
}

