terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.1.0"
    }
  }
}
provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-user12"
    storage_account_name = "gastuser12"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

module "keyvault" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=keyvault/v1.0.0"
  # also any inputs for the module (see below)
  keyvault_name = "gakvuser12"
  resource_group = {
    name = "rg-user12"
    location = "polandcentral"    
  }
  network_acls = {
    bypass = "AzureServices"
  }
}

module "mssql_server" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=mssql_server/v1.0.0"
  # also any inputs for the module (see below)
  resource_group = {
    name = "rg-user12"
    location = "polandcentral"    
  }
  sql_server_admin = "mssqladmin1"
  sql_server_name = "mssqlname1"
  sql_server_version = "12.0"  
}
