# Contribution Guide

## Branch and PR Workflow

1. Create a feature branch
2. Keep changes focused and modular
3. Open a pull request with clear summary and validation details

## Coding Standards

- Use `[CmdletBinding()]` for reusable functions
- Provide clear parameter definitions and defaults
- Favor robust error handling (`try/catch`) where integration points exist
- Avoid hard dependencies for optional modules

## Required Checks

Before requesting review:

- Ensure PowerShell syntax is valid
- Confirm Intune scripts still install/detect/uninstall correctly
- Confirm no secrets were introduced
- Update docs for architecture or workflow changes
