locals {
  common_tags = {
    projeto  = var.projeto
    ambiente = var.tag-ambiente
    dono     = var.tag-dono
    ccusto   = var.tag-ccusto
  }
}
