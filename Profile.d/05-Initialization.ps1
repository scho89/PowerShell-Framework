# Initialize working directory
if ((Get-Location).Path -eq $HOME) {
    Set-Location -Path C:\wd -ErrorAction SilentlyContinue
}

# Optional module initializations (uncomment to use):
# Import-Module -Name Terminal-Icons
# oh-my-posh init pwsh --config ~/pure.omp.json | Invoke-Expression
