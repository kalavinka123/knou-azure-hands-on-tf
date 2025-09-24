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

variable "knou_mall_subnet" {
  type = object({
    id   = string
  })
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}