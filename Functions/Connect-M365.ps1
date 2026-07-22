function Connect-M365 {
    [CmdletBinding()]
    param(
        [switch]$Exchange,
        [switch]$Graph,
        [string[]]$GraphScopes = @(
            'User.Read.All',
            'Organization.Read.All'
        )
    )

    $connectExchange = $Exchange
    $connectGraph = $Graph

    if (-not $Exchange -and -not $Graph) {
        $connectExchange = $true
        $connectGraph = $true
    }

    if ($connectExchange) {
        Connect-Exchange
    }

    if ($connectGraph) {
        Connect-Graph -Scopes $GraphScopes
    }
}
