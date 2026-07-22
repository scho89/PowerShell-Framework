function Connect-Graph {
    [CmdletBinding()]
    param(
        [string[]]$Scopes = @(
            'User.Read.All',
            'Organization.Read.All'
        )
    )

    if (-not (Get-Command -Name Connect-MgGraph -ErrorAction SilentlyContinue)) {
        throw "Connect-MgGraph is unavailable. Install Microsoft.Graph first."
    }

    Connect-MgGraph -Scopes $Scopes -NoWelcome
}
