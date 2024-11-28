// servicebus.bicep

param serviceBusNamespaceName string
param location string = resourceGroup().location
param skuName string = 'Standard'
param skuTier string = 'Standard'
param queueName string = 'myQueue' // Nombre de la cola que se va a crear

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2023-01-01-preview' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    isAutoInflateEnabled: true
    maximumThroughputUnits: 1
  }
}

resource queue 'Microsoft.ServiceBus/namespaces/queues@2023-01-01-preview' = {
  name: queueName
  parent: serviceBusNamespace
  properties: {
    lockDuration: 'PT5M'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    defaultMessageTimeToLive: 'P7D'
    deadLetteringOnMessageExpiration: true
  }
}

output serviceBusNamespaceId string = serviceBusNamespace.id
output queueId string = queue.id
