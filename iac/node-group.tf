resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.id
  node_group_name = format("%s", aws_eks_cluster.main.id)

  node_role_arn = aws_iam_role.eks_nodes_role.arn

  instance_types = var.nodes_instance_sizes

  subnet_ids = data.aws_ssm_parameter.private_subnets[*].value

  launch_template {
    id      = aws_launch_template.custom.id
    version = aws_launch_template.custom.latest_version
  }

  scaling_config {
    desired_size = lookup(var.auto_scale_options, "desired")
    max_size     = lookup(var.auto_scale_options, "max")
    min_size     = lookup(var.auto_scale_options, "min")
  }


  capacity_type = "ON_DEMAND"

  labels = {
    "ingress/ready" = true
    "capacity/os"   = "AMAZON_LINUX"
    "capacity/arch" = "AMD64"
    "capacity/type" = "ON_DEMAND"
  }

  depends_on = [
    aws_eks_access_entry.nodes,
    aws_iam_role_policy_attachment.cni,
    aws_iam_role_policy_attachment.nodes,
    aws_iam_role_policy_attachment.ecr,
    aws_iam_role_policy_attachment.ssm,
    aws_iam_role_policy_attachment.cloudwatch,
    aws_iam_role_policy_attachment.ebs_csi
  ]

  tags = {
    "kubernetes.io/cluster/${var.project_name}" = "owned"
    "Name"                                      = "${var.project_name}-eksNode"
  }

  timeouts {
    create = "1h"
    update = "2h"
    delete = "2h"
  }

  update_config {
    max_unavailable = 1
  }
}