// main.bicep

@minLength(1)
param location string // Ubicación del despliegue, pasado como parámetro

// Parámetros de la VNet
param vnetName string = 'myVnethectorh'
param vnetAddressPrefix string = '10.0.0.0/16'
param subnets array = [
  {
    name: 'subnet1'
    addressPrefix: '10.0.1.0/24'
  }
  {                                                                                                                           
    name: 'subnet2'
    addressPrefix: '10.0.2.0/24'
  }
]

// Llamada al módulo de la VNet
module vnetModule './modules/vnet.bicep' = {
  name: 'vnetDeploymenthectorh'
  params: {
    vnetName: vnetName
    location: location
    addressPrefix: vnetAddressPrefix
    subnets: subnets
  }
}

output vnetId string = vnetModule.outputs.vnetId

// Parámetros del Key Vault
param keyVaultName string = 'myKeyVault-${uniqueString(resourceGroup().id, 'kv')}'

// Llamada al módulo del Key Vault
module keyVaultModule './modules/keyvault.bicep' = {
  name: 'deployKeyVault'
  params: {
    keyVaultName: keyVaultName
    location: location
  }
}

// Parámetros del SQL Server y Base de Datos
param sqlServerName string = 'mySqlServer-${uniqueString(resourceGroup().id, 'sql')}'
param sqlAdminUsername string = 'sqlAdmin'
@secure()
param sqlAdminPassword string
param sqlDbName string = 'myDatabasehectorh'

// Llamada al módulo de SQL Server y Base de Datos
module sqlModule './modules/sql.bicep' = {
  name: 'sqlDeploymenthectorh'
  params: {
    sqlServerName: sqlServerName
    location: location
    sqlAdminUsername: sqlAdminUsername
    sqlAdminPassword: sqlAdminPassword
    sqlDbName: sqlDbName
  }
}

output sqlServerFQDN string = sqlModule.outputs.sqlServerFQDN
output sqlDbConnectionString string = sqlModule.outputs.sqlDbConnectionString

// Parámetros del Service Bus
param serviceBusNamespaceName string = 'myServiceBusNamespace-${uniqueString(resourceGroup().id, 'sb')}'
param queueName string = 'myQueuehectorh' // Nombre de la cola que se va a crear

// Llamada al módulo de Service Bus
module serviceBusModule './modules/servicebus.bicep' = {
  name: 'serviceBusDeployment'
  params: {
    serviceBusNamespaceName: serviceBusNamespaceName
    location: location
    queueName: queueName
  }
}

output serviceBusNamespaceId string = serviceBusModule.outputs.serviceBusNamespaceId
output queueId string = serviceBusModule.outputs.queueId

// Parámetros del App Service
param appServicePlanName string = 'myAppServicePlan'
param appName string = 'myWebApp-${uniqueString(resourceGroup().id, 'app')}'

// Llamada al módulo de App Service
module appServiceModule './modules/appservice.bicep' = {
  name: 'appServiceDeploymenthectorh'
  params: {
    appServicePlanName: appServicePlanName
    appName: appName
    location: location
  }
}

output appServicePlanId string = appServiceModule.outputs.appServicePlanId
output webAppId string = appServiceModule.outputs.webAppId
