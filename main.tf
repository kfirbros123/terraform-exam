

module "aws_infra" {
  source = "./mods"
  VPC_CIDR_RANGE = "10.0.0.0/16" # VPC CIDR range
  SUBNET_COUNT   = 2             # Subnet count
  INSTANCE_TYPE  = "t2.micro"    # Instance type
  IF_PUBLIC_IP   = true          # Whether a public IP should be assigned
}