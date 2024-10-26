variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}
variable "subnet_cidr" {
  description = "Subents CIDR blocks"
  type        = list(string)
}
