$optionalModules = @(
    'PSReadLine'
    'ExchangeOnlineManagement'
    'Microsoft.Graph'
)

foreach ($moduleName in $optionalModules) {
    try {
        Import-Module -Name $moduleName -ErrorAction Stop
    }
    catch {
        Write-Verbose ("Optional module '{0}' is not available." -f $moduleName)
    }
}
