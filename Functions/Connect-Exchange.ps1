function Connect-Exchange {
    [CmdletBinding()]
    param()

    if (-not (Get-Command -Name Connect-ExchangeOnline -ErrorAction SilentlyContinue)) {
        throw "Connect-ExchangeOnline is unavailable. Install ExchangeOnlineManagement first."
    }

    Connect-ExchangeOnline -ShowBanner:$false
}
