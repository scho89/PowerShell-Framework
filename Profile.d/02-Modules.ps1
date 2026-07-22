$optionalModules = @(
    'PSReadLine'
    'ExchangeOnlineManagement'
    'Microsoft.Graph'
)

foreach ($moduleName in $optionalModules) {
    try {
        Import-Module -Name $moduleName -ErrorAction Stop
    }
    catch {}
}
