Set-StrictMode -Version Latest

# Initialize global variables for the framework
if (-not (Test-Path variable:global:prefix)) {
    $global:prefix = ""
}

$script:FrameworkRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$script:ProfileDirectory = Join-Path -Path $script:FrameworkRoot -ChildPath 'Profile.d'
$script:FunctionsDirectory = Join-Path -Path $script:FrameworkRoot -ChildPath 'Functions'
$script:ModulesDirectory = Join-Path -Path $script:FrameworkRoot -ChildPath 'Modules'

function Write-FrameworkLoadError {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [System.Management.Automation.ErrorRecord]$ErrorRecord
    )

    Write-Warning ("[PowerShell-Framework] Failed to load '{0}': {1}" -f $Path, $ErrorRecord.Exception.Message)
}

function Import-OptionalModules {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return
    }

    Get-ChildItem -Path $Path -Recurse -File | Where-Object { $_.Extension -in @('.psd1', '.psm1') } | Sort-Object -Property FullName | ForEach-Object {
        $moduleFile = $_.FullName
        try {
            Import-Module -Name $moduleFile -ErrorAction Stop
        }
        catch {
            Write-FrameworkLoadError -Path $moduleFile -ErrorRecord $_
        }
    }
}

if (Test-Path -LiteralPath $script:ProfileDirectory) {
    Get-ChildItem -Path $script:ProfileDirectory -Filter '*.ps1' -File | Sort-Object -Property Name | ForEach-Object {
        $profileFile = $_.FullName
        try {
            . $profileFile
        }
        catch {
            Write-FrameworkLoadError -Path $profileFile -ErrorRecord $_
        }
    }
}

if (Test-Path -LiteralPath $script:FunctionsDirectory) {
    Get-ChildItem -Path $script:FunctionsDirectory -Filter '*.ps1' -File | Sort-Object -Property Name | ForEach-Object {
        $functionFile = $_.FullName
        try {
            . $functionFile
        }
        catch {
            Write-FrameworkLoadError -Path $functionFile -ErrorRecord $_
        }
    }
}

Import-OptionalModules -Path $script:ModulesDirectory
