resource "aws_eks_access_entry" "nodes" {
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = aws_iam_role.eks_nodes_role.arn
  type          = "EC2_LINUX"
}

resource "aws_eks_access_entry" "github_oidc_role" {
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = var.github_actions_role_arn
  type          = "STANDARD"

  depends_on = [aws_eks_cluster.main]
}

resource "aws_eks_access_entry" "svc_user" {
  count        = var.svc_user_arn != "" ? 1 : 0
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = var.svc_user_arn
  type          = "STANDARD"

  depends_on = [aws_eks_cluster.main]
}

resource "aws_eks_access_policy_association" "github_oidc_role_admin" {
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = aws_eks_access_entry.github_oidc_role.principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.github_oidc_role]
}

resource "aws_eks_access_policy_association" "svc_github_user_admin" {
  count        = var.svc_user_arn != "" ? 1 : 0
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = aws_eks_access_entry.svc_user[0].principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.svc_user]
}