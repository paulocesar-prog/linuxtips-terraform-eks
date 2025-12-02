resource "helm_release" "istio_ingress" {
  name             = "istio-ingressgateway"
  chart            = "gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  namespace        = "istio-system"
  create_namespace = true

  version = var.istio_version

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "service.ports[0].name"
    value = "http"
  }

  set {
    name  = "service.ports[0].port"
    value = "80"
  }

  set {
    name  = "service.ports[0].targetPort"
    value = "31257"
  }

  set {
    name  = "service.nodePorts.http"
    value = "31257"
  }

  set {
    name  = "autoscaling.minReplicas"
    value = var.istio_min_replicas
  }

  set {
    name  = "autoscaling.targetCPUUtilizationPercentage"
    value = var.istio_cpu_threshold
  }

  set {
    name  = "resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "resources.limits.memory"
    value = "256Mi"
  }

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod,
    aws_eks_node_group.main,
    aws_eks_access_policy_association.github_oidc_role_admin
  ]
}

resource "kubectl_manifest" "target_binding_443" {
  yaml_body = <<YAML
apiVersion: elbv2.k8s.aws/v1beta1
kind: TargetGroupBinding
metadata:
  name: istio-ingress
  namespace: istio-system
spec:
  serviceRef:
    name: istio-ingressgateway
    port: 80
  targetGroupARN: ${aws_lb_target_group.main.arn}
  targetType: instance
YAML
  depends_on = [
    helm_release.istio_ingress,
    aws_eks_cluster.main,
    aws_eks_access_policy_association.github_oidc_role_admin
  ]
}