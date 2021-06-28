variable "region" {
  description = "Enter AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "key_pair" {
  default = "aws-key-Frankfurt"
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "allow_ports" {
  description = "List open ports"
  type        = list(any)
  default     = ["80", "22", "443", "8080"]
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = "false"
}

variable "common_tag" {
  description = "Tags for all resource"
  type        = map(string)
  default = {
    Owner       = "Hashi"
    Project     = "Sokil"
    CostCenter  = "3000"
    Environment = "Web "
  }
}
