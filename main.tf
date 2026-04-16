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
  databases = {
    name                 = "user12-db1"
    size                 = 10
    sku                  = S0
    #storage_account_type = string
    collation            = "SQL_Latin1_General_CP1_CI_AS"
  }
}

module "service_plan" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=service_plan/v2.0.0"
  # also any inputs for the module (see below)
  app_service_plan_name = "gasplanuser12"
  resource_group = {
    name = "rg-user12"
    location = "polandcentral"    
  }
  sku_name = "B1"
  tags = {
     name = "service_plan_b1"
  } 
}

module "managed_identity" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=managed_identity/v1.0.0"
  # also any inputs for the module (see below)
  name = "mi-app-user12"
  resource_group = {
    name = "rg-user12"
    location = "polandcentral"    
  }
}

module "app_service" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=app_service/v1.0.0"
  # also any inputs for the module (see below)
  resource_group = {
    name = "rg-user12"
    location = "polandcentral"    
  }
  app_service_name = "app-service-name-user12"
  app_service_plan_id = module.service_plan.app_service_plan.id
  app_settings = {}
  identity_client_id = module.managed_identity.managed_identity_client_id
  identity_id = module.managed_identity.managed_identity_id
}

module "application_insights" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=application_insights/v1.0.0"
  # also any inputs for the module (see below)
  application_insights_name = "application-insights-name-user12"
  log_analytics_name = "log-analytics-name-user12" 
  resource_group = {
    name = "rg-user12"
    location = "polandcentral"    
  }
}

module "container_registry" {
  source = "git::https://github.com/pchylak/global_azure_2026_ccoe.git?ref=container_registry/v1.0.0"
  # also any inputs for the module (see below)
  container_registry_name = "containerregistrynameuser12"
  resource_group = {
    name = "rg-user12"
    location = "polandcentral"    
  }
}
