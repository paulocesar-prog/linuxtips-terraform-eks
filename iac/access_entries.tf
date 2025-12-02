resource "aws_eks_access_entry" "nodes" {
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = aws_iam_role.eks_nodes_role.arn
  type          = "EC2_LINUX"
}

resource "aws_eks_access_entry" "github_oidc_role" {
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = "arn:aws:iam::760337697893:role/OIDCGithubAccessRole"
  type          = "STANDARD"

  depends_on = [aws_eks_cluster.main]
}

resource "aws_eks_access_entry" "svc_user" {
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = "arn:aws:iam::760337697893:user/svc_github" #SUBSTITUIR PELO USER REAL
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
  cluster_name  = aws_eks_cluster.main.id
  principal_arn = aws_eks_access_entry.svc_user.principal_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.svc_user]
}