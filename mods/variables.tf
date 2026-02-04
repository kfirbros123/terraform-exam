variable "VPC_CIDR_RANGE"{ default = "10.0.0.0/16"}

variable "SUBNET_COUNT"{  default = 2}

variable "INSTANCE_TYPE"{      default = "t2.micro"}

variable "IF_PUBLIC_IP"{ 
    default = true 
    }
  

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-0532be01f26a3de55" # Add ami for amazon linux here 
  }
}