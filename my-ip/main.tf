data "http" "my_ip" {
  url = "http://ipconfig.io"
}

output "ip_with_cidr" {
  value = "${chomp(data.http.my_ip.body)}/32"
}

output "ip" {
  value = chomp(data.http.my_ip.body)
}
