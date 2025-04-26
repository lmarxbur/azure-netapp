# Create Network Interface- VM1
resource "azurerm_network_interface" "vm1-nic" {
  name                = "vm1-nic"
  location            = azurerm_resource_group.RG-1.location
  resource_group_name = azurerm_resource_group.RG-1.name

  ip_configuration {
    name                          = "internal_1"
    subnet_id                     = azurerm_subnet.subnet-1.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Create Network Interface- VM2
resource "azurerm_network_interface" "vm2-nic" {
  name                = "vm2-nic"
  location            = azurerm_resource_group.RG-1.location
  resource_group_name = azurerm_resource_group.RG-1.name

  ip_configuration {
    name                          = "internal_2"
    subnet_id                     = azurerm_subnet.subnet-2.id
    private_ip_address_allocation = "Dynamic"
    }
  }



#######################TMP-TEST####################
  # Create Network Interface- VM2a
resource "azurerm_network_interface" "vm2a-nic" {
  name                = "vm2a-nic"
  location            = azurerm_resource_group.RG-1.location
  resource_group_name = azurerm_resource_group.RG-1.name

  ip_configuration {
    name                          = "internal_2"
    subnet_id                     = azurerm_subnet.subnet-2.id
    private_ip_address_allocation = "Dynamic"
    }
  }
#######################TMP-TEST####################


 # Create Network Interface- VM3
resource "azurerm_network_interface" "vm3-nic" {
  name                = "vm3-nic"
  location            = azurerm_resource_group.RG-1.location
  resource_group_name = azurerm_resource_group.RG-1.name

  ip_configuration {
    name                          = "internal_3"
    subnet_id                     = azurerm_subnet.subnet-3.id
    private_ip_address_allocation = "Dynamic"
  }
}

  # Create Network Interface- VM4
resource "azurerm_network_interface" "vm4-nic" {
  name                = "vm4-nic"
  location            = azurerm_resource_group.RG-1.location
  resource_group_name = azurerm_resource_group.RG-1.name

  ip_configuration {
    name                          = "internal_4"
    subnet_id                     = azurerm_subnet.subnet-4.id
    private_ip_address_allocation = "Dynamic"
  }
}



# Create VM1
resource "azurerm_linux_virtual_machine" "vm1" {
  name                            = "vm1"
  resource_group_name             = azurerm_resource_group.RG-1.name
  location                        = azurerm_resource_group.RG-1.location
  size                            = var.vm_size
  admin_username                  = "vm1"
  disable_password_authentication = false
  admin_password                  = "!Password1"
  network_interface_ids = [
    azurerm_network_interface.vm1-nic.id,
  ]
  #os_profile{
  # Custom Data for NFS mount
  custom_data = base64encode(<<EOF
#!/bin/bash
sudo mkdir /mnt/fs1

#sudo sed -i 's\var/www/html\mnt/fs1/apache2/\g' /etc/apache2/sites-available/000-default.conf
#sudo sleep 30
#sudo sed -i 's\It works\Apache2 on AZURE Terraform: AZURE ALB\g' /mnt/fs1/apache2/index.html
#sudo sed -i 's\/var/www\/mnt/fs1/apache2\g' /etc/apache2/apache2.conf
#sudo service apache2 restart
EOF
  )
  #}
  boot_diagnostics {
    #enabled ="true"
  }


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = "50"
  }
  source_image_reference {
    publisher = "canonical"
    #offer= "0001-com-ubuntu-server-focal"
    offer = "0001-com-ubuntu-server-jammy"
    sku   = "22_04-lts-gen2"
    #sku= "20_04-lts-gen2"
    version = "latest"
  }
  depends_on = [
    azurerm_netapp_volume.volume1
  ]
}

# # Create VM2
# resource "azurerm_linux_virtual_machine" "vm2" {
#   name                            = "vm2"
#   resource_group_name             = azurerm_resource_group.RG-1.name
#   location                        = azurerm_resource_group.RG-1.location
#   size                            = "Standard_DS1_v2"
#   admin_username                  = "vm1"
#   disable_password_authentication = false
#   admin_password                  = "!Password1"
#   network_interface_ids = [
#     azurerm_network_interface.vm2-nic.id,
#   ]
#   #os_profile{
#   # Custom Data for NFS mount    
#   custom_data = base64encode(<<EOF
# #!/bin/bash
# sudo mkdir /mnt/fs1
# sudo mkdir /etc/smbcredentials
# echo "username=rg1storageacct" >> /etc/smbcredentials/rg1storageacct.cred
# echo "password=${azurerm_storage_account.rg1storageacct.primary_access_key}" >> /etc/smbcredentials/rg1storageacct.cred
# sudo chmod 600 /etc/smbcredentials/rg1storageacct.cred
# sudo mount -t cifs //rg1storageacct.file.core.windows.net/fs10001 /mnt/fs1 -o credentials=/etc/smbcredentials/rg1storageacct.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30
# echo "//rg1storageacct.file.core.windows.net/fs10001 /mnt/fs1 cifs  credentials=/etc/smbcredentials/rg1storageacct.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" | sudo tee -a /etc/fstab
# sudo apt update -y
# #sudo apt install apache2 -y
# #export INSTALL_TOKEN=$(curl --location --request POST "https://api.boomi.com/api/rest/v1/aae-TYRM50/InstallerToken/InstallerToken" --header "Authorization: Basic Qk9PTUlfVE9LRU4uamFjcXVlcy5nZW50aWxlK0xNVGVtcEBraXRlcGlwZS5jb206NTYzZDE5NjEtMjBmYy00NThlLTk1YWUtNGY5M2ZmODU4MWI4" --header 'Content-Type: application/json' --data-raw '{"installType":"GATEWAY","durationMinutes": 30}' | grep -o -P '(?<=token=\").*(?=\" e)')
# #wget https://platform.boomi.com/atom/molecule_install64.sh
# #chmod 655 molecule_install64.sh
# mkdir /home/molecule_local
#   mkdir /home/molecule_local_temp
#   chmod 655 /home/molecule_local
#   chmod 655 /home/molecule_local_temp
# #  ./molecule_install64.sh -q -console -VinstallToken=$INSTALL_TOKEN -VatomName=azure_mol -VaccountId=aae-TYRM50 -VlocalPath=/home/molecule_local -VlocalTempPath=/home/molecule_local_temp -dir /mnt/fs1/molecule
# #sudo sed -i 's\var/www/html\mnt/fs1/apache2/\g' /etc/apache2/sites-available/000-default.conf
# #sudo sleep 30
# #sudo sed -i 's\It works\Apache2 on AZURE Terraform: AZURE ALB\g' /mnt/fs1/apache2/index.html
# #sudo sed -i 's\/var/www\/mnt/fs1/apache2\g' /etc/apache2/apache2.conf
# #sudo service apache2 restart
# EOF
#   )
#   #}
#   boot_diagnostics {
#     #enabled ="true"
#   }


#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#     disk_size_gb         = "50"
#   }
#   source_image_reference {
#     publisher = "canonical"
#     #offer= "0001-com-ubuntu-server-focal"
#     offer = "0001-com-ubuntu-server-jammy"
#     sku   = "22_04-lts-gen2"
#     #sku= "20_04-lts-gen2"
#     version = "latest"
#   }
#   depends_on = [
#     azurerm_storage_account.rg1storageacct
#   ]
# }

##################VM2aT###################
# Create VM2a
# resource "azurerm_linux_virtual_machine" "vm2a" {
#   name                            = "vm2a"
#   resource_group_name             = azurerm_resource_group.RG-1.name
#   location                        = azurerm_resource_group.RG-1.location
#   size                            = "Standard_DS1_v2"
#   admin_username                  = "vm1"
#   disable_password_authentication = false
#   admin_password                  = "!Password1"
#   network_interface_ids = [
#     azurerm_network_interface.vm2a-nic.id,
#   ]
#   #os_profile{
#   # Custom Data for NFS mount    
#   custom_data = base64encode(<<EOF
# #!/bin/bash
# sudo mkdir /mnt/fs1
# sudo mkdir /etc/smbcredentials
# echo "username=rg1storageacct" >> /etc/smbcredentials/rg1storageacct.cred
# echo "password=${azurerm_storage_account.rg1storageacct.primary_access_key}" >> /etc/smbcredentials/rg1storageacct.cred
# sudo chmod 600 /etc/smbcredentials/rg1storageacct.cred
# sudo mount -t cifs //rg1storageacct.file.core.windows.net/fs10001 /mnt/fs1 -o credentials=/etc/smbcredentials/rg1storageacct.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30
# echo "//rg1storageacct.file.core.windows.net/fs10001 /mnt/fs1 cifs  credentials=/etc/smbcredentials/rg1storageacct.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" | sudo tee -a /etc/fstab
# sudo apt update -y
# #sudo apt install apache2 -y
# #export INSTALL_TOKEN=$(curl --location --request POST "https://api.boomi.com/api/rest/v1/aae-TYRM50/InstallerToken/InstallerToken" --header "Authorization: Basic Qk9PTUlfVE9LRU4uamFjcXVlcy5nZW50aWxlK0xNVGVtcEBraXRlcGlwZS5jb206NTYzZDE5NjEtMjBmYy00NThlLTk1YWUtNGY5M2ZmODU4MWI4" --header 'Content-Type: application/json' --data-raw '{"installType":"GATEWAY","durationMinutes": 30}' | grep -o -P '(?<=token=\").*(?=\" e)')
# #wget https://platform.boomi.com/atom/molecule_install64.sh
# #chmod 655 molecule_install64.sh
# mkdir /home/molecule_local
#   mkdir /home/molecule_local_temp
#   chmod 655 /home/molecule_local
#   chmod 655 /home/molecule_local_temp
# #  ./molecule_install64.sh -q -console -VinstallToken=$INSTALL_TOKEN -VatomName=azure_mol -VaccountId=aae-TYRM50 -VlocalPath=/home/molecule_local -VlocalTempPath=/home/molecule_local_temp -dir /mnt/fs1/molecule
# #sudo sed -i 's\var/www/html\mnt/fs1/apache2/\g' /etc/apache2/sites-available/000-default.conf
# #sudo sleep 30
# #sudo sed -i 's\It works\Apache2 on AZURE Terraform: AZURE ALB\g' /mnt/fs1/apache2/index.html
# #sudo sed -i 's\/var/www\/mnt/fs1/apache2\g' /etc/apache2/apache2.conf
# #sudo service apache2 restart
# EOF
#   )
#   #}
#   boot_diagnostics {
#     #enabled ="true"
#   }


#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#     disk_size_gb         = "50"
#   }
#   source_image_reference {
#     publisher = "canonical"
#     #offer= "0001-com-ubuntu-server-focal"
#     offer = "0001-com-ubuntu-server-jammy"
#     sku   = "22_04-lts-gen2"
#     #sku= "20_04-lts-gen2"
#     version = "latest"
#   }
#   depends_on = [
#     azurerm_storage_account.rg1storageacct
#   ]
# }
##################TMP-TEST###################




# Create VM3
# resource "azurerm_linux_virtual_machine" "vm3" {
#   name                            = "vm3"
#   resource_group_name             = azurerm_resource_group.RG-1.name
#   location                        = azurerm_resource_group.RG-1.location
#   size                            = "Standard_DS1_v2"
#   admin_username                  = "vm1"
#   disable_password_authentication = false
#   admin_password                  = "!Password1"
#   network_interface_ids = [
#     azurerm_network_interface.vm3-nic.id,
#   ]
#   #os_profile{
#   # Custom Data for NFS mount    
#   custom_data = base64encode(<<EOF
# #!/bin/bash
# sudo mkdir /mnt/fs1
# sudo mkdir /etc/smbcredentials
# echo "username=rg1storageacct" >> /etc/smbcredentials/rg1storageacct.cred
# echo "password=${azurerm_storage_account.rg1storageacct.primary_access_key}" >> /etc/smbcredentials/rg1storageacct.cred
# sudo chmod 600 /etc/smbcredentials/rg1storageacct.cred
# sudo mount -t cifs //rg1storageacct.file.core.windows.net/fs10001 /mnt/fs1 -o credentials=/etc/smbcredentials/rg1storageacct.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30
# echo "//rg1storageacct.file.core.windows.net/fs10001 /mnt/fs1 cifs  credentials=/etc/smbcredentials/rg1storageacct.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" | sudo tee -a /etc/fstab
# sudo apt update -y
# #sudo apt install apache2 -y
# #export INSTALL_TOKEN=$(curl --location --request POST "https://api.boomi.com/api/rest/v1/aae-TYRM50/InstallerToken/InstallerToken" --header "Authorization: Basic Qk9PTUlfVE9LRU4uamFjcXVlcy5nZW50aWxlK0xNVGVtcEBraXRlcGlwZS5jb206NTYzZDE5NjEtMjBmYy00NThlLTk1YWUtNGY5M2ZmODU4MWI4" --header 'Content-Type: application/json' --data-raw '{"installType":"GATEWAY","durationMinutes": 30}' | grep -o -P '(?<=token=\").*(?=\" e)')
# #wget https://platform.boomi.com/atom/molecule_install64.sh
# #chmod 655 molecule_install64.sh
# mkdir /home/molecule_local
#   mkdir /home/molecule_local_temp
#   chmod 655 /home/molecule_local
#   chmod 655 /home/molecule_local_temp
#  # ./molecule_install64.sh -q -console -VinstallToken=$INSTALL_TOKEN -VatomName=azure_mol -VaccountId=aae-TYRM50 -VlocalPath=/home/molecule_local -VlocalTempPath=/home/molecule_local_temp -dir /mnt/fs1/molecule
# #sudo sed -i 's\var/www/html\mnt/fs1/apache2/\g' /etc/apache2/sites-available/000-default.conf
# #sudo sleep 30
# #sudo sed -i 's\It works\Apache2 on AZURE Terraform: AZURE ALB\g' /mnt/fs1/apache2/index.html
# #sudo sed -i 's\/var/www\/mnt/fs1/apache2\g' /etc/apache2/apache2.conf
# #sudo service apache2 restart
# EOF
#   )
#   #}
#   boot_diagnostics {
#     #enabled ="true"
#   }


#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#     disk_size_gb         = "50"
#   }
#   source_image_reference {
#     publisher = "canonical"
#     #offer= "0001-com-ubuntu-server-focal"
#     offer = "0001-com-ubuntu-server-jammy"
#     sku   = "22_04-lts-gen2"
#     #sku= "20_04-lts-gen2"
#     version = "latest"
#   }
#   depends_on = [
#     azurerm_storage_account.rg1storageacct
#   ]
# }



# Create VM4
# resource "azurerm_linux_virtual_machine" "vm4" {
#   name                            = "vm4"
#   resource_group_name             = azurerm_resource_group.RG-1.name
#   location                        = azurerm_resource_group.RG-1.location
#   size                            = "Standard_DS1_v2"
#   admin_username                  = "vm1"
#   disable_password_authentication = false
#   admin_password                  = "!Password1"
#   network_interface_ids = [
#     azurerm_network_interface.vm4-nic.id,
#   ]
#   #os_profile{
#   # Custom Data for NFS mount    
#   custom_data = base64encode(<<EOF
# #!/bin/bash
# sudo mkdir /mnt/fs1
# sudo mkdir /etc/smbcredentials
# echo "username=rg1storageacct" >> /etc/smbcredentials/rg1storageacct.cred
# echo "password=${azurerm_storage_account.rg1storageacct.primary_access_key}" >> /etc/smbcredentials/rg1storageacct.cred
# sudo chmod 600 /etc/smbcredentials/rg1storageacct.cred
# sudo mount -t cifs //rg1storageacct.file.core.windows.net/fs10001 /mnt/fs1 -o credentials=/etc/smbcredentials/rg1storageacct.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30
# echo "//rg1storageacct.file.core.windows.net/fs10001 /mnt/fs1 cifs  credentials=/etc/smbcredentials/rg1storageacct.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" | sudo tee -a /etc/fstab
# sudo apt update -y
# #sudo apt install apache2 -y
# #export INSTALL_TOKEN=$(curl --location --request POST "https://api.boomi.com/api/rest/v1/aae-TYRM50/InstallerToken/InstallerToken" --header "Authorization: Basic Qk9PTUlfVE9LRU4uamFjcXVlcy5nZW50aWxlK0xNVGVtcEBraXRlcGlwZS5jb206NTYzZDE5NjEtMjBmYy00NThlLTk1YWUtNGY5M2ZmODU4MWI4" --header 'Content-Type: application/json' --data-raw '{"installType":"GATEWAY","durationMinutes": 30}' | grep -o -P '(?<=token=\").*(?=\" e)')
# #wget https://platform.boomi.com/atom/molecule_install64.sh
# #chmod 655 molecule_install64.sh
# mkdir /home/molecule_local
#   mkdir /home/molecule_local_temp
#   chmod 655 /home/molecule_local
#   chmod 655 /home/molecule_local_temp
# #  ./molecule_install64.sh -q -console -VinstallToken=$INSTALL_TOKEN -VatomName=azure_mol -VaccountId=aae-TYRM50 -VlocalPath=/home/molecule_local -VlocalTempPath=/home/molecule_local_temp -dir /mnt/fs1/molecule
# #sudo sed -i 's\var/www/html\mnt/fs1/apache2/\g' /etc/apache2/sites-available/000-default.conf
# #sudo sleep 30
# #sudo sed -i 's\It works\Apache2 on AZURE Terraform: AZURE ALB\g' /mnt/fs1/apache2/index.html
# #sudo sed -i 's\/var/www\/mnt/fs1/apache2\g' /etc/apache2/apache2.conf
# #sudo service apache2 restart
# EOF
#   )
#   #}
#   boot_diagnostics {
#     #enabled ="true"
#   }


#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#     disk_size_gb         = "50"
#   }
#   source_image_reference {
#     publisher = "canonical"
#     #offer= "0001-com-ubuntu-server-focal"
#     offer = "0001-com-ubuntu-server-jammy"
#     sku   = "22_04-lts-gen2"
#     #sku= "20_04-lts-gen2"
#     version = "latest"
#   }
#   depends_on = [
#     azurerm_storage_account.rg1storageacct
#   ]
# }


