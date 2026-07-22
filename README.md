# M365-PowerShell-Framework

M365-PowerShell-Framework is a centralized, version-controlled PowerShell framework for Microsoft 365 support engineers.

## Design Goals

- Modular and easy to extend
- Enterprise-ready and version-controlled
- GitHub-friendly collaboration model
- Intune-friendly deployment as a Win32 app
- Compatible with PowerShell 5.1 and PowerShell 7

## Repository Architecture

```text
.
├── CompanyProfile.ps1
├── Version.txt
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── DEVELOPMENT.md
├── INSTALLATION.md
├── Profile.d/
│   ├── 01-Aliases.ps1
│   ├── 02-Modules.ps1
│   ├── 03-PSReadLine.ps1
│   └── 04-Prompt.ps1
├── Functions/
│   ├── Connect-M365.ps1
│   ├── Connect-Exchange.ps1
│   ├── Connect-Graph.ps1
│   └── Get-TenantInfo.ps1
├── Modules/
│   └── .gitkeep
├── Intune/
│   ├── Install.ps1
│   ├── Uninstall.ps1
│   └── Detection.ps1
└── .github/
    ├── workflows/
    │   └── build-intunewin.yml
    └── pull_request_template.md
```

## Installation Path

The framework is designed to be installed to:

`C:\ProgramData\Company\PowerShell`

A lightweight user profile can dot-source `CompanyProfile.ps1` from that location.

## Profile Loading Sequence

`CompanyProfile.ps1` performs the following in order:

1. Loads all `Profile.d/*.ps1` scripts by filename order.
2. Loads all `Functions/*.ps1` scripts.
3. Imports optional custom modules from `Modules/` (`.psd1` and `.psm1`).
4. Handles missing modules gracefully and logs warnings instead of failing the shell.

## Built-In Initial Features

### Aliases

- `ll` -> `Get-ChildItem`
- `grep` -> `Select-String`

### Optional Module Loading

The framework attempts to import:

- `PSReadLine`
- `ExchangeOnlineManagement`
- `Microsoft.Graph`

Missing modules are handled gracefully.

### PSReadLine Settings

- `PredictionSource`: `History`
- `EditMode`: `Windows`

### Prompt

The prompt displays username, computer name, and current location:

`[username@COMPUTER] C:\Path >`

## Extending the Framework

### Add a New Function

1. Create a new `Functions/<Verb>-<Noun>.ps1` file.
2. Define a function with `[CmdletBinding()]`.
3. Restart shell or re-source `CompanyProfile.ps1`.

### Add a New Alias

1. Add the alias to `Profile.d/01-Aliases.ps1`, or create a new ordered profile script.
2. Keep filename ordering in mind for deterministic load behavior.

## Intune Deployment

Use scripts in `Intune/`:

- `Install.ps1` deploys the framework to `C:\ProgramData\Company\PowerShell`
- `Detection.ps1` verifies `Version.txt` exists
- `Uninstall.ps1` removes the framework

## CI/CD Workflow

`.github/workflows/build-intunewin.yml`:

- Validates PowerShell syntax
- Creates a release archive
- Includes an Intune Win32 packaging placeholder step
- Publishes release artifacts when tags matching `v*` are pushed

For deeper operational details, see:

- [INSTALLATION.md](INSTALLATION.md)
- [DEVELOPMENT.md](DEVELOPMENT.md)
- [CONTRIBUTING.md](CONTRIBUTING.md)
