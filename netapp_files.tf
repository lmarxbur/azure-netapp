# Create an Azure NetApp Files Account
resource "azurerm_netapp_account" "netapp1" {
  name                = "netapp1"
  resource_group_name = azurerm_resource_group.RG-1.name
  location            = azurerm_resource_group.RG-1.location
}

# Create a NetApp Capacity Pool (within the NetApp account)
resource "azurerm_netapp_pool" "cap_pool" {
  name                = "cap-pool"
  account_name        = azurerm_netapp_account.netapp1.name
  resource_group_name = azurerm_resource_group.RG-1.name
  location            = azurerm_resource_group.RG-1.location

  service_level = "Standard" # Can also be Premium or Ultra
  size_in_tb    = 4          # Size in TB

}

# Create a NetApp Volume (using NFS protocol as an example)
resource "azurerm_netapp_volume" "volume1" {
  name                = "volume1"
  account_name        = azurerm_netapp_account.netapp1.name # Explicitly defining the account_name
  pool_name           = azurerm_netapp_pool.cap_pool.name
  resource_group_name = azurerm_resource_group.RG-1.name
  location            = azurerm_resource_group.RG-1.location
  protocols           = ["NFSv4.1"] # Correct attribute for specifying protocols
  subnet_id           = azurerm_subnet.subnet-2.id
  volume_path         = "vol1"
  service_level       = "Standard"

  storage_quota_in_gb = 100 # Minimum value allowed is 50 GiB




  export_policy_rule {
    allowed_clients   = ["0.0.0.0/0"] # Adjust to restrict access as needed
    rule_index        = 1
    protocols_enabled = ["NFSv4.1"] # Ensure this rule is for NFSv4.1
    # readonly          = false          # Allow read-write access
  }
}


# resource "null_resource" "azurerm_netapp_file_system" {
#   provisioner "local-exec" {
#     command = <<EOT
#       az netappfiles volume create 
#         --resource-group RG-1 \
#         --account-name netapp1 \
#         --pool-name cap-pool \
#         --location RG-1 \
#         --name netapp-filesystem \
#         --subnet "/subscriptions/<subscription-id>/resourceGroups/RG-1/providers/Microsoft.Network/virtualNetworks/vnet-1/subnets/subnet-2" \
#     EOT
#   }
# }

# resource "azurerm_netapp_volume_mount_target" "netapp" {
#   name                 = "netapp-mount-target"
#   netapp_account_name  = azurerm_netapp_account.netapp1.name
#   resource_group_name  = azurerm_resource_group.RG-1.name
#   pool_name            = azurerm_netapp_pool.cap-pool_name
#   volume_name          = azurerm_netapp_volume.volume1.name
#   subnet_id            = azurerm_subnet.subnet-2.id
#   # You can specify an IP address for the mount target if needed
#   ip_address           = "10.10.3.4"
# }
  
# resource "null_resource" "mount_target" {
#   provisioner "local-exec" {
#     command = <<EOT
#       az netappfiles mount-target create \
#         --resource-group RG-1 \
#         --account-name netapp1 \
#         --file-system-name netapp-filesystem \
#         --subnet subnet-2 \
#         --protocol-type NFSv4.1 \
#         --location RG-1 \
#     EOT
#   }

#  depends_on = [azurerm_subnet.subnet-2]
#}