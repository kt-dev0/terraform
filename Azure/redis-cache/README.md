```markdown
# Azure Redis Cache Deployment with VNet Injection using Terraform (AVM)

This Terraform configuration deploys an Azure Cache for Redis instance using the [Azure Verified Modules (AVM)](https://registry.terraform.io/modules/Azure/avm-res-cache-redis/azurerm/latest). It aligns with the principles of the **Azure Well-Architected Framework (WAF)**, incorporating considerations across all five pillars:

- Reliability
- Security
- Cost Optimization
- Operational Excellence
- Performance Efficiency

## Architecture Overview

This deployment includes:
- A resource group
- A virtual network (VNet)
- An Azure Cache for Redis (Premium tier) instance configured for VNet injection

---

## Requirements

- Terraform version: `~> 1.7`
- Providers:
  - `azurerm ~> 4.0`
  - `azapi ~> 2.0`
  - `modtm ~> 0.3`
  - `random ~> 3.5`

Azure CLI must be authenticated (`az login`) with appropriate access to your subscription.

---

## Deployment Instructions

1. Clone the repository or copy the configuration files locally.
2. Run `terraform init` to initialize the working directory.
3. Run `terraform plan` to review the execution plan.
4. Run `terraform apply` to deploy the resources.

---

## Terraform Resources

### Resource Group

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "rg-redis"
  location = "East US"
}
```

### Virtual Network and Subnet

```hcl
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
```

### Redis Cache with VNet Injection

```hcl
module "redis_cache" {
  source              = "Azure/avm-res-cache-redis/azurerm"
  version             = "1.0.0"
  name                = "redis-injected"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Premium"
  capacity            = 1
  subnet_resource_id  = azurerm_subnet.redis_subnet.id
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  tags = {
    environment = "dev"
    project     = "redis-injected"
  }
}
```

---

## Alignment with Azure Well-Architected Framework

### 1. Reliability
- The Redis instance uses the **Premium SKU**, which supports high availability and automatic failover.
- VNet integration ensures reliable and predictable connectivity.
- Subnet delegation to Redis ensures compliance with Azure's supported network architecture.

### 2. Security
- Redis is deployed inside a **Virtual Network**, reducing exposure to public internet.
- **TLS 1.2** is enforced to secure data in transit.
- Non-SSL port access is explicitly disabled.

### 3. Cost Optimization
- The `capacity` is configurable, allowing appropriate sizing for the workload.
- By isolating Redis in its own subnet, organizations can better track and manage its network-related costs.

### 4. Operational Excellence
- Terraform ensures **infrastructure as code**, enabling repeatable, version-controlled deployments.
- The module uses Azure Verified Modules (AVM), providing consistency and long-term maintainability.

### 5. Performance Efficiency
- Redis is deployed with the option to enable clustering and scaling through AVM parameters.
- VNet injection enhances performance by reducing network latency for internal services accessing Redis.

---

## Customization

You may adjust the following parameters as needed:

- `sku_name`: Choose between `Basic`, `Standard`, or `Premium`
- `capacity`: Scale the instance size as required
- `location`: Deploy to your preferred Azure region
- `tags`: Apply business or environment-specific metadata

---


```markdown
### Troubleshooting
If you're running Terraform inside WSL and encounter this error:

```
Error: `subscription_id` is a required provider property
```

Terraform may not detect Azure CLI credentials correctly.

**Fix:** Add `subscription_id` and `tenant_id` to your provider block:

```hcl
provider "azurerm" {
  features {}
  subscription_id = "your-subscription-id"
  tenant_id       = "your-tenant-id"
}
```

Get these values by running:

```bash
 az account show --query "{subscriptionId:id, tenantId:tenantId}" --output json
```
```

Let me know if you want this added to an existing README section for Terraform setup.









---

## License

This project uses the [MIT License](https://opensource.org/licenses/MIT).

---

## References

- [Azure Cache for Redis Documentation](https://learn.microsoft.com/en-us/azure/azure-cache-for-redis/)
- [Azure Verified Modules on Terraform Registry](https://registry.terraform.io/modules/Azure/avm-res-cache-redis/azurerm/latest)
- [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/)

```