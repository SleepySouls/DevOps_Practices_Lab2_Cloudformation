resource "aws_cloudformation_stack" "vpc_stack" {
  name          = "vpc-stack"
  template_body = file("${path.module}/modules/vpc.yaml")  

  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  tags = {
    Name = "vpc-stack"
  }
}

resource "aws_cloudformation_stack" "route_table_stack" {
  name          = "route-table-stack"
  template_body = file("${path.module}/modules/route_tables.yaml")  

  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  depends_on = [aws_cloudformation_stack.vpc_stack]

  tags = {
    Name = "route-table-stack"
  }
}

resource "aws_cloudformation_stack" "nat_gateway_stack" {
  name          = "nat-gateway-stack"
  template_body = file("${path.module}/modules/nat_gateway.yaml")  

  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  depends_on = [aws_cloudformation_stack.route_table_stack]
  tags = {
    Name = "nat-gateway-stack"
  }
}

resource "aws_cloudformation_stack" "security_groups_stack" {
  name = "security-groups-stack"

  template_body = file("${path.module}/modules/security_groups.yaml")

  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
  
  depends_on = [aws_cloudformation_stack.nat_gateway_stack]
  tags = {
    Name = "security-groups-stack"
  }
}

resource "aws_cloudformation_stack" "ec2_instances_stack" {
  name          = "ec2-instances-stack"
  template_body = file("${path.module}/modules/ec2_instances.yaml")  

  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  depends_on = [aws_cloudformation_stack.security_groups_stack]
  tags = {
    Name = "ec2-instances-stack"
  }
}