variable "location" {
  default = "eastus"
}

variable "projeto" {}
variable "regiao" {
  type    = string
  default = "eastus2"
}
variable "tag-dono" {
  type        = string
  description = "Dono do projeto"
  default     = "julianorib"
}

variable "tag-ambiente" {
  type        = string
  description = "Ambiente do projeto"
  default     = "Dev"
}

variable "tag-ccusto" {
  type        = string
  description = "Centro de Custo do projeto"
  default     = "Tecnologia"
}