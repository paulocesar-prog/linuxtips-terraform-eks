resource "aws_launch_template" "custom" {

  name = "${var.project_name}"

  image_id = data.aws_ssm_parameter.eks_optimized_ami_133.value

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 100
      volume_type = "gp3"
    }
  }
  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags, {
      Name = "${var.project_name}-eksNode"
    })
  }

  user_data = base64encode(templatefile("${path.module}/files/user-data/user-data.tpl", {
    CLUSTER_NAME                     = aws_eks_cluster.main.id
    KUBERNETES_ENDPOINT              = aws_eks_cluster.main.endpoint
    KUBERNETES_CERTIFICATE_AUTHORITY = aws_eks_cluster.main.certificate_authority.0.data
  }))
}