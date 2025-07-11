# Git Account Switcher Script
# Description: Automate switching between Git accounts with user input and credential management
# Author: Script Repository
# Version: 2.0
# Usage: .\git-account-switcher.ps1 [-Action switch|show|clear] [-Name "username"] [-Email "email@domain.com"]
# Features: Interactive input, email validation, credential clearing, flexible parameter handling

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("switch", "show", "clear")]
    [string]$Action = "switch",
    
    [string]$Name,
    [string]$Email,
    [switch]$ClearCredentials,
    [switch]$Interactive
)

# Colors for output
$InfoColor = "Green"
$WarningColor = "Yellow"
$ErrorColor = "Red"
$HeaderColor = "Cyan"

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $InfoColor
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $WarningColor
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $ErrorColor
}

function Write-Header {
    param([string]$Message)
    Write-Host "`n=== $Message ===" -ForegroundColor $HeaderColor
}

# Define account configurations
# Removed predefined accounts - now uses user input for flexibility and security

function Get-UserInput {
    param(
        [string]$Prompt,
        [string]$DefaultValue = "",
        [switch]$Secure
    )
    
    if ($DefaultValue) {
        $promptText = "$Prompt [$DefaultValue]"
    } else {
        $promptText = $Prompt
    }
    
    if ($Secure) {
        $input = Read-Host -Prompt $promptText -AsSecureString
        return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($input))
    } else {
        $input = Read-Host -Prompt $promptText
        if ([string]::IsNullOrWhiteSpace($input) -and $DefaultValue) {
            return $DefaultValue
        }
        return $input
    }
}

function Validate-Email {
    param([string]$Email)
    
    $emailRegex = '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return $Email -match $emailRegex
}

function Get-CurrentGitConfig {
    try {
        $currentName = git config --global user.name 2>$null
        $currentEmail = git config --global user.email 2>$null
        
        return @{
            Name = $currentName
            Email = $currentEmail
        }
    }
    catch {
        return @{
            Name = "Not configured"
            Email = "Not configured"
        }
    }
}

function Clear-GitCredentials {
    Write-Info "Clearing stored Git credentials..."
    
    try {
        # Clear Windows Credential Manager
        $gitCredentials = cmdkey /list | Select-String "git:" | ForEach-Object {
            if ($_ -match "Destino: LegacyGeneric:target=(.*)") {
                $matches[1]
            }
        }
        
        foreach ($cred in $gitCredentials) {
            Write-Info "Removing credential: $cred"
            cmdkey /delete:"LegacyGeneric:target=$cred" | Out-Null
        }
        
        # Clear Git credential cache
        git config --global --unset credential.helper 2>$null
        
        Write-Info "Git credentials cleared successfully"
    }
    catch {
        Write-Warning "Some credentials could not be cleared: $($_.Exception.Message)"
    }
}

function Set-GitAccount {
    param(
        [string]$Name,
        [string]$Email,
        [string]$Description
    )
    
    Write-Header "Switching to: $Description"
    
    try {
        # Set Git configuration
        git config --global user.name $Name
        git config --global user.email $Email
        
        # Verify configuration
        $newName = git config --global user.name
        $newEmail = git config --global user.email
        
        if ($newName -eq $Name -and $newEmail -eq $Email) {
            Write-Info "✅ Git account switched successfully!"
            Write-Info "Name: $newName"
            Write-Info "Email: $newEmail"
            
            if ($ClearCredentials) {
                Clear-GitCredentials
            }
            
            return $true
        }
        else {
            Write-Error "Failed to set Git configuration"
            return $false
        }
    }
    catch {
        Write-Error "Error switching Git account: $($_.Exception.Message)"
        return $false
    }
}

function Show-CurrentAccount {
    Write-Header "Current Git Configuration"
    
    $current = Get-CurrentGitConfig
    Write-Host "Name:  $($current.Name)" -ForegroundColor White
    Write-Host "Email: $($current.Email)" -ForegroundColor White
}

function Get-GitAccountInput {
    Write-Header "Git Account Configuration"
    
    $current = Get-CurrentGitConfig
    
    Write-Host "Current Configuration:" -ForegroundColor $InfoColor
    Write-Host "  Name:  $($current.Name)"
    Write-Host "  Email: $($current.Email)"
    Write-Host ""
    
    # Get user input
    do {
        $userName = Get-UserInput -Prompt "Enter Git username" -DefaultValue $current.Name
        if ([string]::IsNullOrWhiteSpace($userName)) {
            Write-Warning "Username cannot be empty. Please try again."
        }
    } while ([string]::IsNullOrWhiteSpace($userName))
    
    do {
        $userEmail = Get-UserInput -Prompt "Enter Git email" -DefaultValue $current.Email
        if ([string]::IsNullOrWhiteSpace($userEmail)) {
            Write-Warning "Email cannot be empty. Please try again."
        } elseif (-not (Validate-Email $userEmail)) {
            Write-Warning "Invalid email format. Please enter a valid email address."
            $userEmail = ""
        }
    } while ([string]::IsNullOrWhiteSpace($userEmail))
    
    return @{
        Name = $userName
        Email = $userEmail
    }
}

function Show-Usage {
    Write-Header "Git Account Switcher - Usage Guide"
    
    Write-Host "Available Actions:" -ForegroundColor $HeaderColor
    Write-Host "  switch    - Switch to a different Git account (default)"
    Write-Host "  show      - Show current Git configuration"
    Write-Host "  clear     - Clear stored Git credentials"
    Write-Host ""
    
    Write-Host "Parameters:" -ForegroundColor $HeaderColor
    Write-Host "  -Name           Pre-specify Git username"
    Write-Host "  -Email          Pre-specify Git email"
    Write-Host "  -ClearCredentials   Clear Windows credentials after switching"
    Write-Host "  -Interactive    Force interactive mode (prompt for all inputs)"
    Write-Host ""
    
    Write-Host "Usage Examples:" -ForegroundColor $HeaderColor
    Write-Host "  .\git-account-switcher.ps1"
    Write-Host "  .\git-account-switcher.ps1 -Action show"
    Write-Host "  .\git-account-switcher.ps1 -Action clear"
    Write-Host "  .\git-account-switcher.ps1 -Name 'John Doe' -Email 'john@example.com'"
    Write-Host "  .\git-account-switcher.ps1 -ClearCredentials"
    Write-Host "  .\git-account-switcher.ps1 -Interactive"
}

# Main execution
try {
    Write-Header "Git Account Switcher v2.0"
    
    switch ($Action.ToLower()) {
        "show" {
            Show-CurrentAccount
            exit 0
        }
        
        "clear" {
            Clear-GitCredentials
            exit 0
        }
        
        "switch" {
            # Determine how to get account information
            if ($Interactive -or (-not $Name -and -not $Email)) {
                # Interactive mode or no parameters provided
                $accountInfo = Get-GitAccountInput
                $userName = $accountInfo.Name
                $userEmail = $accountInfo.Email
            } else {
                # Parameters provided
                if ($Name -and $Email) {
                    $userName = $Name
                    $userEmail = $Email
                } elseif ($Name -and -not $Email) {
                    Write-Warning "Email not provided. Prompting for email..."
                    do {
                        $userEmail = Get-UserInput -Prompt "Enter Git email"
                        if (-not (Validate-Email $userEmail)) {
                            Write-Warning "Invalid email format. Please enter a valid email address."
                            $userEmail = ""
                        }
                    } while ([string]::IsNullOrWhiteSpace($userEmail))
                } elseif ($Email -and -not $Name) {
                    Write-Warning "Name not provided. Prompting for name..."
                    do {
                        $userName = Get-UserInput -Prompt "Enter Git username"
                        if ([string]::IsNullOrWhiteSpace($userName)) {
                            Write-Warning "Username cannot be empty. Please try again."
                        }
                    } while ([string]::IsNullOrWhiteSpace($userName))
                }
            }
            
            # Validate email format
            if (-not (Validate-Email $userEmail)) {
                Write-Error "Invalid email format: $userEmail"
                exit 1
            }
            
            # Set the Git account
            $success = Set-GitAccount -Name $userName -Email $userEmail -Description "User Account"
            
            if (-not $success) {
                exit 1
            }
        }
        
        default {
            Write-Error "Unknown action: $Action"
            Show-Usage
            exit 1
        }
    }
}
catch {
    Write-Error "Script execution failed: $($_.Exception.Message)"
    exit 1
}

# Show final status for switch action
if ($Action -eq "switch") {
    Write-Host ""
    Show-CurrentAccount
}
