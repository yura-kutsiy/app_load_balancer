
output "find-aws_lb-hier" {
  value = aws_lb.app.dns_name
}

output "availability_zones" {
  value = data.aws_availability_zones.availability_zone.names
}

output "region_name" {
  value = data.aws_region.current.name
}

output "region_description" {
  value = data.aws_region.current.description
}
