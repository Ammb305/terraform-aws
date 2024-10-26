variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}
variable "subnet_cidr" {
  description = "Subents CIDR blocks"
  type        = list(string)
}
variable "subnet_names" {
  description = "Subents Names"
  type        = list(string)
  default     = ["PublicSubnet1", "PublicSubnet2"]
}