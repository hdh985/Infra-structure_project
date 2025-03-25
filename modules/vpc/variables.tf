variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string) # length = 2
}

variable "private_subnet_cidrs" {
  type = list(string) # length = 4
}

variable "availability_zones" {
  type = list(string) # length = 2 (예: [az-a, az-c])
}
