# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.80.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
 
}
resource "azurerm_resource_group" "RG-1" {
  name     = "RG-1"
  location = "East US 2"
}


resource "azurerm_resource_group_template_deployment" "register_network_provider" {
  name                = "register-network-provider"
  resource_group_name = "RG-1"
  template_content    = <<-EOT
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Resources/providers",
      "apiVersion": "2021-04-01",
      "properties": {
        "registrationState": "Registered"
      },
      "name": "Microsoft.Network"
    }
  ]
}
EOT
  deployment_mode = "Incremental"  # Can also be "Complete" depending on your needs
}

resource "null_resource" "register_network_provider" {
  provisioner "local-exec" {
    command = "az provider register --namespace Microsoft.Network"
  }
}

resource "null_resource" "register_storage_provide" {
  provisioner "local-exec" {
    command = "az provider register --namespace Microsoft.Storage"
  }
}


variable "prefix" {
  default = "tf-azure"
}

#