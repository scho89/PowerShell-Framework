function global:prompt {
    $userName = [Environment]::UserName
    $computerName = [Environment]::MachineName
    $location = (Get-Location).Path

    return ('[{0}@{1}] {2} > ' -f $userName, $computerName, $location)
}
