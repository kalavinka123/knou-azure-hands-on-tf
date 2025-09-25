data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "knou_mall_kv" {
  name                        = var.key_vault_name
  location                    = var.knou_mall_rg.location
  resource_group_name         = var.knou_mall_rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90

  sku_name = "standard"

  rbac_authorization_enabled = true
  public_network_access_enabled = true

  network_acls {
    bypass = "AzureServices"
    default_action = "Deny"
    ip_rules = toset([var.my_ip])
    virtual_network_subnet_ids = toset([var.knou_mall_subnet.id])
  }
}

resource "azurerm_role_assignment" "knou_mall_kv_role-assignment" {
  scope                = azurerm_key_vault.knou_mall_kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "knou_mall_kv_secret" {
  name         = var.key_vault_secret_name
  value        = var.key_vault_secret_password
  key_vault_id = azurerm_key_vault.knou_mall_kv.id

  depends_on = [azurerm_role_assignment.knou_mall_kv_role-assignment]
}