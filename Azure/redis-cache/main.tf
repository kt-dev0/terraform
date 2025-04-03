resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-redis"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-redis"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "redis_subnet" {
  name                 = "subnet-redis"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "redis_cache" {
  source              = "Azure/avm-res-cache-redis/azurerm"
  version             = "0.3.0" 
  location            = "East US"
  name                = "redis-tf"
  resource_group_name =  azurerm_resource_group.rg.name

  # Reliability
  sku_name            = "Premium"  
  capacity            = 2
  enable_non_ssl_port = false

  # Security
  subnet_resource_id  = azurerm_subnet.redis_subnet.id
  # Performance Efficiency
  shard_count         = 2

  # Operational Excellence
  enable_telemetry    = false

  tags = {
    environment = "dev"
    project     = "myProject"
  }
}
