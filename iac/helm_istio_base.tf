resource "helm_release" "istio_base" {
  name       = "istio-base"
  chart      = "base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  namespace  = "istio-system"

  create_namespace = true

  version = var.istio_version

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_access_policy_association.github_oidc_role_admin
  ]
}

resource "helm_release" "istiod" {
  name       = "istio"
  chart      = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  namespace  = "istio-system"

  create_namespace = true

  version = var.istio_version

  set {
    name  = "sidecarInjectorWebhook.rewriteAppHTTPProbe"
    value = "false"
  }

  set {
    name  = "meshConfig.enableTracing"
    value = "true"
  }

  set {
    name  = "pilot.pdb.enabled"
    value = "false"
  }

  depends_on = [
    helm_release.istio_base,
    aws_eks_cluster.main,
    aws_eks_access_policy_association.github_oidc_role_admin,
    helm_release.alb_ingress_controller
  ]
}
