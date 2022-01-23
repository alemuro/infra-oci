provider "kubernetes" {
  config_path = "~/.kube/leonard.conf"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/leonard.conf"
  }
}