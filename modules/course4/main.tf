resource "azurerm_network_interface" "knou_mall_nic" {
  name                = "knou_mall_nic"
  location            = var.knou_mall_rg.location
  resource_group_name = var.knou_mall_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.knou_mall_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.knou_mall_ip.id
  }
}

resource "azurerm_network_security_group" "knou_mall_sg" {
  name                = "mall-vm1-nsg"
  location            = var.knou_mall_rg.location
  resource_group_name = var.knou_mall_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_ip
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "knou_mall_nic_sg_asso" {
  network_interface_id          = azurerm_network_interface.knou_mall_nic.id
  network_security_group_id     = azurerm_network_security_group.knou_mall_sg.id
}

resource "azurerm_public_ip" "knou_mall_ip" {
  name                = "mall-vm-ip"
  resource_group_name = var.knou_mall_rg.name
  location            = var.knou_mall_rg.location
  allocation_method   = "Static"
}

resource "azurerm_linux_virtual_machine" "knou_mall_vm" {
  name                = "mall-vm1"
  resource_group_name = var.knou_mall_rg.name
  location            = var.knou_mall_rg.location
  size                = "Standard_B1ls"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.knou_mall_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.admin_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = var.tags
}