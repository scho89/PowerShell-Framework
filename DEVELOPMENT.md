# Development Guide

## Local Development

1. Clone repository
2. Edit scripts in `Profile.d/`, `Functions/`, `Modules/`, or `Intune/`
3. Validate syntax before pushing changes

## Manual Syntax Validation

```powershell
Get-ChildItem -Recurse -Filter *.ps1 | ForEach-Object {
    [void][System.Management.Automation.Language.Parser]::ParseFile($_.FullName, [ref]$null, [ref]$errors)
}
$errors
```

## Framework Conventions

- Keep framework components modular
- Use ordered profile scripts in `Profile.d/`
- Use approved verb-noun naming for functions
- Handle optional dependencies gracefully
- Keep compatibility with PowerShell 5.1 and PowerShell 7

## Versioning

Update `Version.txt` for release-impacting changes.
