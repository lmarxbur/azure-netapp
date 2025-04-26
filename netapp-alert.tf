resource "azurerm_monitor_metric_alert" "netapp" {
  name                = "netapp-metric-alert"
  resource_group_name = azurerm_resource_group.RG-1.name
  #location            = "East US"
  description = "Alert when volume exceeds usage threshold"
  severity    = 3
  enabled     = true
  frequency   = "PT1M"
  #evaluation_frequency = "PT5M"
  scopes = [azurerm_netapp_volume.volume1.id] # Reference your volume's ID

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "netapp"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80 # Set your threshold as percentage of capacity

    #dimensions = []
  }

  action {
    action_group_id = azurerm_monitor_action_group.netapp.id
  }
}

resource "azurerm_monitor_action_group" "netapp" {
  name                = "netapp action group"
  resource_group_name = azurerm_resource_group.RG-1.name
  short_name          = "netapp"

  email_receiver {
    name          = "email"
    email_address = "lmarx@proto-net.com"
  }
}