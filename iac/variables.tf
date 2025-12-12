variable "aws_region" {
  description = "Região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome do projeto para prefixar os recursos"
  type        = string
  default     = "linuxtips-eks"
}

variable "cluster_version" {
  description = "Versão do Kubernetes"
  type        = string
  default     = "1.33"
}

variable "node_instance_types" {
  description = "Tipos de instância para os nodes"
  type        = list(string)
  default     = ["t3.small"]
}

variable "node_desired_size" {
  description = "Número desejado de nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Número máximo de nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Número mínimo de nodes"
  type        = number
  default     = 1
}

variable "istio_version" {
  description = "Versão do Istio"
  type        = string
  default     = "1.19.0"
}

variable "istio_min_replicas" {
  description = "Número mínimo de réplicas do Istio Ingress Gateway"
  type        = number
  default     = 1
}

variable "istio_cpu_threshold" {
  description = "Threshold de CPU para autoscaling do Istio"
  type        = number
  default     = 80
}

variable "nlb_name" {
  description = "Nome do Network Load Balancer"
  type        = string
  default     = "linuxtips-eks-nlb"
}

variable "certificate_arn" {
  description = "ARN do certificado SSL para o NLB (deixe vazio para desabilitar TLS listener)"
  type        = string
  default     = "arn:aws:acm:us-east-1:870461445219:certificate/fa7271a0-406a-4cf5-ba87-a45160c037e4"
}

variable "argocd_domain" {
  description = "Domínio para acesso ao ArgoCD"
  type        = string
  default     = "argocd.fabiobartoli.com.br"
}

variable "common_tags" {
  description = "Tags comuns para todos os recursos"
  type        = map(string)
  default = {
    Project     = "linuxtips-eks"
    Environment = "production"
    ManagedBy   = "terraform"
    Owner       = "fabio"
  }
}

variable "addon_cni_version" {
  description = "Versão do Addon VPC CNI"
  type        = string
  default     = "v1.19.5-eksbuild.1"
}

variable "addon_coredns_version" {
  description = "Versão do Addon CoreDNS"
  type        = string
  default     = "v1.12.1-eksbuild.2"
}

variable "addon_kubeproxy_version" {
  description = "Versão do Addon Kube Proxy"
  type        = string
  default     = "v1.33.0-eksbuild.2"
}

variable "addon_pod_identity_version" {
  description = "Versão do Addon EKS Pod Identity Agent"
  type        = string
  default     = "v1.3.8-eksbuild.2"
}

variable "addon_ebs_csi_version" {
  description = "Versão do Addon EBS CSI Driver"
  type        = string
  default     = "v1.46.0-eksbuild.1"
}

variable "addon_efs_csi_version" {
  description = "Versão do Addon EFS CSI Driver"
  type        = string
  default     = "v2.1.10-eksbuild.1"
}

variable "addon_s3_csi_version" {
  description = "Versão do Addon S3 CSI Driver"
  type        = string
  default     = "v1.15.0-eksbuild.1"
}

variable "auto_scale_options" {
  type = object({
    min     = number
    max     = number
    desired = number
  })
  default = {
    min     = 1
    max     = 2
    desired = 2
  }
}

variable "custom_ami" {
  type        = string
  description = "AMI ID dos nodes"
  default     = "ami-03a82ff046da70392"
}

variable "nodes_instance_sizes" {
  type = list(string)
  default = ["t3.small"]
}

variable "ssm_public_subnets" {
  type        = list(string)
  description = "description"
  default = [ "/linuxtips/vpc/public-subnet-1a", "/linuxtips/vpc/public-subnet-1b", "/linuxtips/vpc/public-subnet-1c" ]
}

variable "ssm_private_subnets" {
  type        = list(string)
  description = "description"
  default = [ "/linuxtips/vpc/private-subnet-1a", "/linuxtips/vpc/private-subnet-1b", "/linuxtips/vpc/private-subnet-1c" ]
}

variable "ssm_vpc" {
  type        = string
  description = "description"
  default     = "/linuxtips/vpc/id"
}