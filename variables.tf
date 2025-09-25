# root variables.tf
variable "location" {
  description = "Azure location for all resources"
  type        = string
  default     = "japaneast"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {
    application = "knou_mall"
    service = "web"
    env = "dev"
  }
}

variable "my_ip" {
  description = "My public IP address with /32"
  type        = string
  default     = "xxx.xxx.xxx.xxx/32" ## 내 컴퓨터 IP 공개주소. 터미널에서 `curl ifconfig.me -4` 로 찾을 수 있음.
}

variable "admin_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/xxxxx.pub" ## 공개키 경로 설정. PEM 키의 경우 `ssh-keygen -y -f sample.pem > sample.pub` 로 공개키를 추출할 수 있음.
}

variable "db_server_name" {
  description = "Server name must be at least 3 characters and at most 63 characters. Server name must only contain lowercase letters, numbers, and hyphens."
  type        = string
  default     = "knou-mall-dbadad" ## xxxx 를 임의의 이름으로 바꾸기.
}

variable "db_admin_password" {
  type      = string
  sensitive = true
  default   = "YOUR_PASSWORD" ## DB 암호
}

variable "key_vault_name" {
  type        = string
  default     = "mall-db-keytutu" ## xxxx 를 임의의 이름으로 바꾸기.
}

variable "key_vault_secret_name" {
  type        = string
  default     = "knou-mall-db-admin-pwd"
}

variable "key_vault_secret_password" {
  type      = string
  sensitive = true
  default   = "YOUR_PASSWORD" ## 키 비밀 암호(임의의 패스워드로 바꾸기)
}