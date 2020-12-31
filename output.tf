data "aws_db_instance" "database" {
  db_instance_identifier = "${var.identifier}-${var.environment}"
}

data "kubernetes_ingress" "address" {
  metadata {
    name = "owncloud-lb"
    namespace = "fargate-node"
  }
}

output "database_endpoint" {
    value = "${data.aws_db_instance.database.address}"
}

output "server_dns" {
    value = "${data.kubernetes_ingress.address.load_balancer_ingress}"
}