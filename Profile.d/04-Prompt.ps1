# Initialize global variables if they don't exist
if (-not (Test-Path variable:global:prefix)) {
    $global:prefix = ""
}

function global:prompt {
    try {
        $executionTime = 0
        
        # Safely get execution time from history
        $history = @(Get-History -ErrorAction SilentlyContinue)
        if ($history.Count -ge 1) {
            $lastCommand = $history[-1]
            if ($lastCommand.EndExecutionTime -and $lastCommand.StartExecutionTime) {
                $executionTime = ($lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime).TotalMilliseconds
            }
        }

        # Format and display prompt
        $timestamp = Get-Date -format "MM'/'dd HH:mm:ss"
        $timeString = " {0:#,0} ms" -f $executionTime
        $global:prefix = $timestamp + $timeString

        Write-Host $global:prefix -f yellow -nonewline
        Write-Host (" " + $pwd + ">") -nonewline
    }
    catch {
        # Fallback to simple prompt if error occurs
        Write-Host "PS>" -nonewline
    }
    
    return " "
}
