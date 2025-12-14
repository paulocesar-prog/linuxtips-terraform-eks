resource "helm_release" "argocd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
  namespace        = "argocd"

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }
  set {
    name  = "server.ingress.enabled"
    value = "false"
  }
  set {
    name  = "server.extensions.enabled"
    value = "true"
  }
  set {
    name  = "server.enable.proxy.extension"
    value = "true"
  }
  set {
    name  = "server.extensions.image.repository"
    value = "quay.io/argoprojlabs/argocd-extension-installer"
  }

  set {
    name  = "server.extensions.image.tag"
    value = "v0.0.8"
  }


  set {
    name  = "server.extensions.extensionList[0].name"
    value = "rollout-extension"
  }

  set {
    name  = "server.extensions.extensionList[0].env[0].name"
    value = "EXTENSION_URL"
  }

  set {
    name  = "server.extensions.extensionList[0].env[0].value"
    value = "https://github.com/argoproj-labs/rollout-extension/releases/download/v0.3.6/extension.tar"
  }

  values = [
    file("${path.module}/files/argocd-values.yml")
  ]

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_access_policy_association.github_oidc_role_admin
  ]
}