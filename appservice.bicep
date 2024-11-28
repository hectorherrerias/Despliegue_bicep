// appservice.bicep

param appServicePlanName string
param appName string
param location string = resourceGroup().location
param skuName string = 'S1' // SKU del App Service Plan
param skuTier string = 'Standard' // Tier del App Service Plan

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    tier: skuTier
    capacity: 1
  }
  properties: {
    reserved: false // Cambiar a true si se está utilizando un contenedor de Linux
  }
}

resource webApp 'Microsoft.Web/sites@2023-01-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
}

output appServicePlanId string = appServicePlan.id
output webAppId string = webApp.id
