
# Konfiguracja dostawcy Azure
provider "azurerm" {
  features {}
}

# Dane o istniejącej grupie zasobów (zmień nazwę na swoją)
data "azurerm_resource_group" "example" {
  name = "moja-grupa-zasobow"
}

# Tworzenie konta magazynu
resource "azurerm_storage_account" "example" {
  name                     = "mojekonto${lower(substr(md5(data.azurerm_resource_group.example.id), 0, 8))}" # Unikalna nazwa
  resource_group_name      = data.azurerm_resource_group.example.name
  location                 = data.azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }
}

# Tworzenie kontenera w magazynie
resource "azurerm_storage_container" "example" {
  name                  = "moj-kontener"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

# Wyjście - connection string do magazynu
output "storage_connection_string" {
  value     = azurerm_storage_account.example.primary_connection_string
  sensitive = true
}

# Wyjście - URL kontenera
output "container_url" {
  value = "${azurerm_storage_account.example.primary_blob_endpoint}${azurerm_storage_container.example.name}"
}