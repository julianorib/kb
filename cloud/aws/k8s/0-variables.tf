variable "project_name" {}
variable "region" {}
variable "user" {}
variable "tag-ambiente" {
  type = string
  description = "Ambiente do Projeto"
  default = "test"
}
variable "k8s_version" {
  type        = string
  description = "Versao do Kubernetes"
  default     = "1.32"
}
variable "eks_public_access" {
  type = bool
  description = "Acesso publico ao EKS"
  default = false
}
variable "eks_instance_types" {
  type = list
  description = "EKS Node Instance"
  default = ["t3.micro"]
}
variable "eks_ondemand_desired" {
  type = number
  description = "EKS Node Desired"
  default = 2
}
variable "eks_ondemand_Max" {
  type = number
  description = "EKS Node Max"
  default = 3
}
variable "eks_ondemand_Min" {
  type = number
  description = "EKS Node Min"
  default = 1
}

variable "eks_spot_desired" {
  type = number
  description = "EKS Node Desired"
  default = 2
}
variable "eks_spot_Max" {
  type = number
  description = "EKS Node Max"
  default = 3
}
variable "eks_spot_Min" {
  type = number
  description = "EKS Node Min"
  default = 1
}

