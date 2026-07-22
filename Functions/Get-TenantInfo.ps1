function Get-TenantInfo {
    [CmdletBinding()]
    param()

    $tenantInfo = [ordered]@{
        Timestamp            = Get-Date
        GraphTenantId        = $null
        GraphAccount         = $null
        ExchangeConnected    = $false
        ExchangeOrganization = $null
    }

    if (Get-Command -Name Get-MgContext -ErrorAction SilentlyContinue) {
        $graphContext = Get-MgContext
        if ($null -ne $graphContext) {
            $tenantInfo.GraphTenantId = $graphContext.TenantId
            $tenantInfo.GraphAccount = $graphContext.Account
        }
    }

    if (Get-Command -Name Get-ConnectionInformation -ErrorAction SilentlyContinue) {
        $exchangeConnection = Get-ConnectionInformation | Select-Object -First 1
        if ($null -ne $exchangeConnection) {
            $tenantInfo.ExchangeConnected = $true
            $tenantInfo.ExchangeOrganization = $exchangeConnection.Organization
        }
    }

    [pscustomobject]$tenantInfo
}
