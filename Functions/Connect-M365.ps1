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

    $connectExchange = $Exchange -or (-not $Exchange -and -not $Graph)
    $connectGraph = $Graph -or (-not $Exchange -and -not $Graph)

    if ($connectExchange) {
        Connect-Exchange
    }

    if ($connectGraph) {
        Connect-Graph -Scopes $GraphScopes
    }
}
