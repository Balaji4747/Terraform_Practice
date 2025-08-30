# this are the outputs for the counts

# output "ec2_public_ip" {
#   value = aws_instance.my_instance[*].public_ip
# }

# output "ec2_private_ip" {
#   value = aws_instance.my_instance[*].private_ip       

# }

# output "ec2_public_dns" {
#   value = aws_instance.my_instance[*].public_dns

# }

# following output is for multiple instances with for_each
output "ec2_public_ip" {
  value = {
    for key, instance in aws_instance.my_instance : key => instance.public_ip
  }
}

output "ec2_private_ip" {
  value = {
    for key, instance in aws_instance.my_instance : key => instance.private_ip
  }
}

output "ec2_public_dns" {
  value = {
    for key, instance in aws_instance.my_instance : key => instance.public_dns
  }
}


