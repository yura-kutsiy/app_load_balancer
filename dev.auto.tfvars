region                     = "eu-central-1"
instance_type              = "t2.micro"
enable_detailed_monitoring = false
allow_ports                = ["80", "22"]

common_tag = {
  Owner       = "Hashi"
  Project     = "Sokil"
  CostCenter  = "4000"
  Environment = "dev "
}
