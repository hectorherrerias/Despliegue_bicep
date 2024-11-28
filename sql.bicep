// sql.bicep

param sqlServerName string
param location string = resourceGroup().location
param sqlAdminUsername string
@secure()
param sqlAdminPassword string
param sqlDbName string

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: sqlServerName
  location: location  // Directamente usar el parámetro 'location'
  properties: {
    administratorLogin: sqlAdminUsername
    administratorLoginPassword: sqlAdminPassword
  }
  sku: {
    name: 'Standard_DTU_100'
    tier: 'Standard'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  name: '${sqlServer.name}/${sqlDbName}'
  location: location  // Usar el mismo parámetro 'location'
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 2147483648
  }
  sku: {
    name: 'S0'
    tier: 'Standard'
  }
}

output sqlServerFQDN string = sqlServer.properties.fullyQualifiedDomainName
output sqlDbConnectionString string = 'Server=${sqlServer.properties.fullyQualifiedDomainName};Database=${sqlDbName};User Id=${sqlAdminUsername};Password=${sqlAdminPassword};'
