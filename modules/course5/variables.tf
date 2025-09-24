variable "knou_mall_rg" {
  type = object({
    name     = string
    location = string
  })
}

variable "my_ip" {
  description = "My public IP address with /32"
  type        = string
}

variable "db_server_name" {
  description = "Server name must be at least 3 characters and at most 63 characters. Server name must only contain lowercase letters, numbers, and hyphens."
  type        = string
}

variable "db_admin_password" {
  type      = string
  description = "Administrator password for PostgreSQL server"
  sensitive = true
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}