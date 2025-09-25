resource "azurerm_postgresql_flexible_server" "knou_mall_db" {
  name                          = var.db_server_name
  resource_group_name           = var.knou_mall_rg.name
  location                      = var.knou_mall_rg.location

  version                       = "14"
  sku_name   = "B_Standard_B1ms"
  storage_mb   = 32768
  storage_tier = "P4"

  public_network_access_enabled = true ## TODO: 연습용; 본래 비추천
  administrator_login           = "azureuser"
  administrator_password        = var.db_admin_password
  zone = 1

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_my_ip" {
  name             = "my-ip-fw"
  server_id        = azurerm_postgresql_flexible_server.knou_mall_db.id
  start_ip_address = split("/", var.my_ip)[0]
  end_ip_address   = split("/", var.my_ip)[0]
}

## Azure 서비스로부터 엑세스 허용
# The Azure feature Allow access to Azure services can be enabled by setting start_ip_address and end_ip_address to 0.0.0.0 which (is documented in the Azure API Docs).
# 참고문서: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_firewall_rule#example-usage-allow-access-to-azure-services
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  name       = "allow-azure-services"
  server_id  = azurerm_postgresql_flexible_server.knou_mall_db.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

## 데이터베이스를 terraform 으로 생성
# postgresql 설치하지 않았으면 밑의 리소스를 전부 커멘트 아웃하여 실행
resource "null_resource" "cmd_create_db" {
  provisioner "local-exec" {
    environment = {
      PGPASSWORD = var.db_admin_password
    }
    command = "psql \"postgresql://azureuser@${azurerm_postgresql_flexible_server.knou_mall_db.fqdn}:5432/postgres?sslmode=require\" -c \"CREATE DATABASE knou_mall;\""
  }

  depends_on = [azurerm_postgresql_flexible_server.knou_mall_db]
}
