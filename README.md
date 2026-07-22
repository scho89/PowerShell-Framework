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
│   ├── 01-Aliases.ps1                # Initialize aliases
│   ├── 02-Modules.ps1                # Import optional modules
│   ├── 03-PSReadLine.ps1             # Configure PSReadLine
│   ├── 04-Prompt.ps1                 # Custom prompt function
│   ├── 05-Initialization.ps1         # Environment initialization
│   └── ##-CustomSettings.ps1         # Add custom profile scripts here
├── Functions/
│   ├── Connect-M365.ps1              # Example: M365 connection
│   ├── Connect-Exchange.ps1          # Example: Exchange connection
│   ├── Connect-Graph.ps1             # Example: Microsoft Graph connection
│   ├── Get-TenantInfo.ps1            # Example: Tenant information
│   ├── Decode-Base64String.ps1       # Example: Utility function
│   ├── Format-Xml.ps1                # Example: Utility function
│   ├── Send-Text.ps1                 # Example: Utility function
│   └── <Verb>-<Noun>.ps1             # Add more functions here
├── Modules/
│   └── .gitkeep                      # Add .psd1 or .psm1 modules here
├── Intune/
│   ├── Install.ps1                   # Installation script
│   ├── Uninstall.ps1                 # Uninstallation script
│   ├── Detection.ps1                 # Intune detection logic
│   ├── Build-IntunePackage.ps1       # Local package builder
│   ├── Build-IntunePackage.bat       # Easy-click builder
│   └── README.md                     # Intune deployment guide
└── .github/
    ├── workflows/
    │   ├── build-intunewin.yml       # CI/CD pipeline
    │   └── ##-custom-workflow.yml    # Add custom workflows here
    └── pull_request_template.md      # PR template
```

## Installation Path

The framework is designed to be installed per-user to:

`$HOME\Documents\PowerShell\Framework`

Each user has their own independent installation and can customize it freely. Changes made by one user do not affect others.

## Profile Loading Sequence

`CompanyProfile.ps1` performs the following in order:

1. Loads all `Profile.d/*.ps1` scripts by filename order:
   - `01-Aliases.ps1` - Defines aliases
   - `02-Modules.ps1` - Imports optional modules (PSReadLine, ExchangeOnlineManagement, Microsoft.Graph)
   - `03-PSReadLine.ps1` - Configures PSReadLine settings (PowerShell 7+)
   - `04-Prompt.ps1` - Custom prompt with execution time tracking
   - `05-Initialization.ps1` - Sets working directory and optional initializations
2. Loads all `Functions/*.ps1` scripts.
3. Imports optional custom modules from `Modules/` (`.psd1` and `.psm1`).
4. Handles missing modules and load errors gracefully without failing the shell.

## Built-In Initial Features

### Aliases

- `ll` -> `Get-ChildItem`
- `grep` -> `Select-String`

### Optional Module Loading

The framework attempts to import:

- `PSReadLine` - Enhanced command-line editing
- `ExchangeOnlineManagement` - Exchange Online management
- `Microsoft.Graph` - Microsoft Graph API access

Missing modules are handled gracefully.

### PSReadLine Settings

- `PredictionSource`: `History` (PowerShell 7+)
- `EditMode`: `Windows`

### Prompt

The prompt displays the current timestamp and command execution time:

```
07/22 11:31:35 49 ms  C:\wd>
```

Features:
- **Timestamp**: MM/dd HH:mm:ss format
- **Execution Time**: Previous command duration in milliseconds
- **Working Directory**: Current path

### Utility Functions

- **Decode-Base64String** - Decodes Base64 strings via pipeline
- **Format-Xml** - Pretty-prints XML content
- **Send-Text** - Simulates keyboard input (useful for automation)

## Extending the Framework

### Add a New Function

1. Create a new `Functions/<Verb>-<Noun>.ps1` file.
2. Define a function with `[CmdletBinding()]`.
3. Restart shell or re-source `CompanyProfile.ps1`.

### Add a New Alias

1. Add the alias to `Profile.d/01-Aliases.ps1`, or create a new ordered profile script.
2. Keep filename ordering in mind for deterministic load behavior.

### Add Profile Configuration

Create a new ordered file in `Profile.d/` (e.g., `Profile.d/06-CustomSettings.ps1`) and it will be loaded automatically.

## Intune Deployment

### Quick Build

```powershell
cd .\Intune
.\Build-IntunePackage.ps1
```

This creates a `.intunewin` package with:
- All framework files
- Install/Uninstall/Detection scripts
- Automatic user profile configuration

See [Intune/README.md](Intune/README.md) for details.

### Installation Behavior

- **Install**: Copies framework to `$HOME\Documents\PowerShell\Framework` and updates user profile
- **Detection**: Verifies `Version.txt` exists
- **Uninstall**: Removes framework and cleans up profile configuration

### Automatic Updates with Remediation Scripts

For **automatic version updates without Win32 redeployment**:

**Features:**
- ✅ Periodic version check via GitHub API
- ✅ Automatic download and install of latest version
- ✅ Compliance tracking in Intune
- ✅ Per-user isolated updates
- ✅ Full audit logging

**Setup:**
1. Edit `Intune/Remediation-Detection.ps1` and `Remediation-Remediate.ps1`
2. Update GitHub owner and repository names
3. Deploy to Intune as Remediation Scripts
4. Create GitHub releases for version updates

→ **[Intune/REMEDIATION.md](Intune/REMEDIATION.md)** for complete setup guide

### Installation Behavior

- **Install**: Copies framework to `C:\ProgramData\Company\PowerShell` and updates All Users profile
- **Detection**: Verifies `Version.txt` exists
- **Uninstall**: Removes framework and cleans up profile configuration

## CI/CD Workflow

`.github/workflows/build-intunewin.yml`:

- Validates PowerShell syntax on all push/PR
- Creates release archives
- Publishes artifacts when tags matching `v*` are pushed

**Note**: Windows runners cost 2x more than Linux. Consider local builds or conditional workflows.

For deeper operational details, see:

- [INSTALLATION.md](INSTALLATION.md) - Installation and deployment guide
- [DEVELOPMENT.md](DEVELOPMENT.md) - Development guidelines
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution process
- [Intune/README.md](Intune/README.md) - Intune package building
