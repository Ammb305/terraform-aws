variable "sg_id" {
  description = "Security Group ID for ELB"
  type        = string
}
variable "subnets" {
  description = "Subnets for ELB"
  type        = list(string)
}
variable "vpc_id" {
  description = "VPC ID for ELB"
  type        = string
}
variable "instances" {
  description = "EC2 Instances"
  type        = list(string)
}