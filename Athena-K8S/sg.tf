resource "aws_security_group_rule" "eks_private_access" {
  depends_on = [ aws_eks_cluster.athena_eks_cluster ]
  type = "ingress"
  from_port = "443"
  to_port = "443"
  protocol = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
  security_group_id = "${aws_eks_cluster.athena_eks_cluster.vpc_config[0].cluster_security_group_id}"
}