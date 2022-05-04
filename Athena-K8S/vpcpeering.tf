#===============================================================================================
resource "aws_vpc_peering_connection" "peering_eksathenanonprod_athenanonprod" {
  # peer_owner_id = "${var.owner_id}"
  peer_vpc_id   = "${var.athenanonprod}"
  vpc_id        = "${module.vpc.vpc_id}"
  peer_region   = "${var.peer_region_east2}"
  auto_accept   = "false"

  tags = {
    Name = "VPC Peering between eksathenanonprod and athenanonprod"
  }
}

resource "aws_vpc_peering_connection_accepter" "athenanonprod" {
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering_eksathenanonprod_athenanonprod.id}"
  auto_accept               = true

  tags = {
    Name = "eksathenanonprod to athenanonprod"
  }
}

# Create a route of eksathenanonprod VPC
resource "aws_route" "route_from_eksathenanonprod_to_athenanonprod_private1" {
  route_table_id            = "${module.vpc.private_route_table_ids[0]}"
  destination_cidr_block    = "${var.athenanonprod_cidr}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering_eksathenanonprod_athenanonprod.id}"
  depends_on = []
}

# Create a route of athenanonprod private route
resource "aws_route" "route_from_athenanonprod_private_to_eksathenanonprod_1" {
  route_table_id            = "${var.athenanonprod_route_private_1}"
  destination_cidr_block    = "${module.vpc.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering_eksathenanonprod_athenanonprod.id}"
  depends_on = []
}
resource "aws_route" "route_from_athenanonprod_private_to_eksathenanonprod_2" {
  route_table_id            = "${var.athenanonprod_route_private_2}"
  destination_cidr_block    = "${module.vpc.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering_eksathenanonprod_athenanonprod.id}"
  depends_on = []
}
resource "aws_route" "route_from_athenanonprod_private_to_eksathenanonprod_3" {
  route_table_id            = "${var.athenanonprod_route_private_3}"
  destination_cidr_block    = "${module.vpc.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering_eksathenanonprod_athenanonprod.id}"
  depends_on = []
}

# Create a route of athenanonprod public route
resource "aws_route" "route_from_athenanonprod_public_to_eksathenanonprod" {
  route_table_id            = "${var.athenanonprod_route_public}"
  destination_cidr_block    = "${module.vpc.vpc_cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peering_eksathenanonprod_athenanonprod.id}"
  depends_on = []
}
# # Create a route of athenanonprod public route
# resource "aws_route" "route_from_eksathenanonprod_to_athenanonprod_public" {
#   route_table_id            = "${module.vpc.private_route_table_ids[0]}"
#   destination_cidr_block    = "${var.athenanonprod_cidr}"
#   vpc_peering_connection_id = "${aws_vpc_peering_connection.peering_eksathenanonprod_athenanonprod.id}"
#   depends_on = []
# }
