resource "helm_release" "kube-prometheus-stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "41.7.0"

  values = [yamlencode({
    alertmanager = {
      ingress = {
        enabled = true
        hosts = [
          "alertmanager.oci.aleix.cloud"
        ]
      }
    }
    grafana = {
      ingress = {
        enabled = true
        hosts = [
          "grafana.oci.aleix.cloud"
        ]
      }
    }
    alertmanager = {
      ingress = {
        enabled = true
        hosts = [
          "alertmanager.oci.aleix.cloud"
        ]
      }
    }
    prometheus = {
      ingress = {
        enabled = true
        hosts = [
          "prometheus.oci.aleix.cloud"
        ]
      }
    }
  })]
}
