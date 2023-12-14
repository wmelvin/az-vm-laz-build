
// Referred to the following Bicep template for direction:
// https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.compute/vm-simple-windows/main.bicep


@description('Location for all resources.')
param rg_location string

@description('Name of the Windows Virtual Machine to create.')
param vm_name string

@description('Size of the Windows Virtual Machine.')
param vm_size string = 'Standard_DS2_v2'

@description('The URN of the VM image to use.')
param vm_image_urn string

@description('Username for the VM.')
param vm_user string

@description('Password for the VM.')
@secure()
param vm_pass string

// @description('Prefix for resource names not passed as params.')
// param name_prefix string = 'demo999'

@description('Name of the Public IP Address to create.')
param pip_name string

@description('Name of the Network Security Group to create.')
param nsg_name string

@description('Name of the Virtual Network to create.')
param vnet_name string

@description('Name of the Subnet to create.')
param subnet_name string

@description('Name of the Network Interface Card to create.')
param nic_name string

/* 
This was failing because "array index '1' is out of bounds"
The vm_image_urn param was delimited by colons, but image_parts[1] was out of bounds,
so maybe there is something about using 'split' that I am missing.
I will hardcode the image parts for now to test the rest of the template.

// 'MicrosoftWindowsDesktop:windows-11:win11-22h2-pro:22621.2283.230901'
var image_publisher = 'MicrosoftWindowsDesktop'
var image_offer = 'windows-11'
var image_sku = 'win11-22h2-pro'
var image_version = '22621.2283.230901'
*/

// Split the image URN into its parts.
var image_parts = split(vm_image_urn, ':')
var image_publisher = image_parts[0]
var image_offer = image_parts[1]
var image_sku = image_parts[2]
var image_version = image_parts[3]


resource public_ip_resource 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: pip_name
  location: rg_location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    publicIPAddressVersion: 'IPv4'
  }
}

resource nsg_resource 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: nsg_name
  location: rg_location
  properties: {
    securityRules: [
      {
        name: 'open-port-3398'
        properties: {
          priority: 900
          access: 'Allow'
          direction: 'Inbound'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource vnet_resource 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnet_name
  location: rg_location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.1.0.0/16']
    }
    subnets: [
      {
        name: subnet_name
        properties: {
          addressPrefix: '10.1.1.0/24'
          networkSecurityGroup: {
            id: nsg_resource.id
          }
        }
      }
    ]
  }
}

resource nic_resource 'Microsoft.Network/networkInterfaces@2023-05-01' = {
  name: nic_name
  location: rg_location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          privateIPAddressVersion: 'IPv4'
          publicIPAddress: {
            id: public_ip_resource.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnet_name, subnet_name)
          }
        }
      }
    ]
  }
  dependsOn: [
    vnet_resource
  ]
}

resource vm_resource 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: vm_name
  location: rg_location
  properties: {
    hardwareProfile: {
      vmSize: vm_size
    }
    osProfile: {
      computerName: vm_name
      adminUsername: vm_user
      adminPassword: vm_pass
    }
    storageProfile: {
      imageReference: {
        publisher: image_publisher
        offer: image_offer
        sku: image_sku
        version: image_version
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic_resource.id
        }
      ]
    }
  }
}

output image_urn string = vm_image_urn
