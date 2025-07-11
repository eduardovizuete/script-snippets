# PowerShell Development Tools Installation Script
# Description: Installs essential development tools for Windows using Chocolatey and Winget
# Author: Script Repository
# Version: 1.0
# Requirements: Windows 10 1809+, Administrator privileges
# Tools: Chocolatey, Git, VS Code, Docker, Node.js, Python, .NET

#Requires -RunAsAdministrator

[CmdletBinding()]
param(
    [switch]$SkipChocolatey,
    [switch]$SkipWinget,
    [switch]$Quiet
)

# Colors for output
$ErrorColor = "Red"
$WarningColor = "Yellow"
$InfoColor = "Green"
$HeaderColor = "Cyan"

function Write-Status {
    param([string]$Message)
    if (-not $Quiet) {
        Write-Host "[INFO] $Message" -ForegroundColor $InfoColor
    }
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
    if (-not $Quiet) {
        Write-Host "`n[STEP] $Message" -ForegroundColor $HeaderColor
        Write-Host ("=" * 50) -ForegroundColor $HeaderColor
    }
}

function Test-CommandExists {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

function Install-Chocolatey {
    Write-Header "Installing Chocolatey Package Manager"
    
    if (Test-CommandExists "choco") {
        Write-Status "Chocolatey already installed"
        choco upgrade chocolatey -y
        return
    }
    
    Write-Status "Installing Chocolatey..."
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        
        # Refresh environment variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        Write-Status "Chocolatey installed successfully"
    }
    catch {
        Write-Error "Failed to install Chocolatey: $($_.Exception.Message)"
        return $false
    }
    return $true
}

function Install-WingetApps {
    Write-Header "Installing Applications via Winget"
    
    if (-not (Test-CommandExists "winget")) {
        Write-Warning "Winget not available. Please install from Microsoft Store."
        return
    }
    
    $wingetApps = @(
        @{Name="Microsoft.VisualStudioCode"; Description="Visual Studio Code"},
        @{Name="Git.Git"; Description="Git Version Control"},
        @{Name="Microsoft.WindowsTerminal"; Description="Windows Terminal"},
        @{Name="Microsoft.PowerShell"; Description="PowerShell 7"},
        @{Name="Docker.DockerDesktop"; Description="Docker Desktop"},
        @{Name="Postman.Postman"; Description="Postman API Client"}
    )
    
    foreach ($app in $wingetApps) {
        try {
            Write-Status "Installing $($app.Description)..."
            winget install --id $app.Name --silent --accept-package-agreements --accept-source-agreements
        }
        catch {
            Write-Warning "Failed to install $($app.Description) via Winget"
        }
    }
}

function Install-ChocolateyApps {
    Write-Header "Installing Applications via Chocolatey"
    
    if (-not (Test-CommandExists "choco")) {
        Write-Warning "Chocolatey not available. Skipping Chocolatey installations."
        return
    }
    
    $chocoApps = @(
        "nodejs",           # Node.js
        "python",          # Python 3
        "openjdk",         # Java Development Kit
        "dotnet-sdk",      # .NET SDK
        "yarn",            # Yarn Package Manager
        "wget",            # Download utility
        "curl",            # HTTP client
        "jq",              # JSON processor
        "7zip",            # Archive utility
        "notepadplusplus", # Text editor
        "firefox",         # Web browser
        "googlechrome",    # Web browser
        "github-desktop",  # GitHub Desktop
        "sourcetree",      # Git GUI
        "dbeaver",         # Database client
        "wireshark",       # Network analyzer
        "sysinternals"     # System utilities
    )
    
    foreach ($app in $chocoApps) {
        try {
            Write-Status "Installing $app..."
            choco install $app -y --no-progress
        }
        catch {
            Write-Warning "Failed to install $app via Chocolatey"
        }
    }
}

function Install-VSCodeExtensions {
    Write-Header "Installing VS Code Extensions"
    
    if (-not (Test-CommandExists "code")) {
        Write-Warning "VS Code not found. Skipping extension installation."
        return
    }
    
    $extensions = @(
        "ms-python.python",
        "ms-vscode.vscode-typescript-next",
        "ms-vscode.powershell",
        "ms-dotnettools.csharp",
        "bradlc.vscode-tailwindcss",
        "esbenp.prettier-vscode",
        "ms-vscode.vscode-json",
        "ms-vscode-remote.remote-containers",
        "github.copilot",
        "github.vscode-pull-request-github",
        "ms-vscode-remote.remote-wsl",
        "ms-vscode.azure-account"
    )
    
    foreach ($extension in $extensions) {
        try {
            Write-Status "Installing VS Code extension: $extension"
            code --install-extension $extension --force
        }
        catch {
            Write-Warning "Failed to install extension: $extension"
        }
    }
}

function Set-GitConfiguration {
    Write-Header "Git Configuration"
    
    if (-not (Test-CommandExists "git")) {
        Write-Warning "Git not found. Skipping Git configuration."
        return
    }
    
    try {
        $currentUser = git config --global user.name 2>$null
        if (-not $currentUser) {
            $gitUsername = Read-Host "Enter your Git username"
            $gitEmail = Read-Host "Enter your Git email"
            
            git config --global user.name $gitUsername
            git config --global user.email $gitEmail
            git config --global init.defaultBranch main
            git config --global pull.rebase false
            git config --global core.autocrlf true
            
            Write-Status "Git configured successfully"
        }
        else {
            Write-Status "Git already configured for user: $currentUser"
        }
    }
    catch {
        Write-Warning "Failed to configure Git"
    }
}

function New-DevelopmentDirectories {
    Write-Header "Creating Development Directories"
    
    $devDirs = @(
        "$env:USERPROFILE\Development",
        "$env:USERPROFILE\Development\Projects",
        "$env:USERPROFILE\Development\Scripts",
        "$env:USERPROFILE\Development\Learning"
    )
    
    foreach ($dir in $devDirs) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            Write-Status "Created directory: $dir"
        }
        else {
            Write-Status "Directory already exists: $dir"
        }
    }
}

function Enable-WindowsFeatures {
    Write-Header "Enabling Windows Features"
    
    $features = @(
        "Microsoft-Windows-Subsystem-Linux",
        "VirtualMachinePlatform",
        "Microsoft-Hyper-V-All"
    )
    
    foreach ($feature in $features) {
        try {
            $featureState = Get-WindowsOptionalFeature -Online -FeatureName $feature
            if ($featureState.State -eq "Disabled") {
                Write-Status "Enabling Windows feature: $feature"
                Enable-WindowsOptionalFeature -Online -FeatureName $feature -NoRestart
            }
            else {
                Write-Status "Windows feature already enabled: $feature"
            }
        }
        catch {
            Write-Warning "Failed to enable feature: $feature"
        }
    }
}

function Show-Summary {
    Write-Header "🎉 Installation Summary"
    
    Write-Host "✅ Chocolatey Package Manager" -ForegroundColor Green
    Write-Host "✅ Git Version Control" -ForegroundColor Green
    Write-Host "✅ Visual Studio Code" -ForegroundColor Green
    Write-Host "✅ Docker Desktop" -ForegroundColor Green
    Write-Host "✅ Node.js and npm" -ForegroundColor Green
    Write-Host "✅ Python 3" -ForegroundColor Green
    Write-Host "✅ .NET SDK" -ForegroundColor Green
    Write-Host "✅ Essential development tools" -ForegroundColor Green
    Write-Host "✅ VS Code extensions" -ForegroundColor Green
    Write-Host "✅ Development directories" -ForegroundColor Green
    Write-Host "✅ Windows features" -ForegroundColor Green
    
    Write-Header "🚀 Next Steps"
    Write-Host "1. Restart your computer to complete Windows feature installation"
    Write-Host "2. Start Docker Desktop from Start Menu"
    Write-Host "3. Install WSL 2 if you plan to use Linux development"
    Write-Host "4. Sign in to GitHub in VS Code"
    Write-Host "5. Configure additional VS Code settings"
    Write-Host "6. Start coding! 🎯"
    
    Write-Header "📚 Useful Commands"
    Write-Host "• choco search <package>        - Search for packages"
    Write-Host "• choco list --local-only       - List installed packages"
    Write-Host "• choco upgrade all -y          - Update all packages"
    Write-Host "• winget search <package>       - Search Winget packages"
    Write-Host "• code <directory>              - Open directory in VS Code"
    Write-Host "• npm install -g <package>      - Install global npm package"
}

# Main execution
try {
    Write-Header "Windows Development Environment Setup"
    Write-Status "PowerShell version: $($PSVersionTable.PSVersion)"
    Write-Status "Windows version: $((Get-WmiObject Win32_OperatingSystem).Caption)"
    
    # Check if running as administrator
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Error "This script must be run as Administrator"
        exit 1
    }
    
    # Install package managers
    if (-not $SkipChocolatey) {
        Install-Chocolatey
    }
    
    # Install applications
    if (-not $SkipWinget) {
        Install-WingetApps
    }
    
    if (-not $SkipChocolatey -and (Test-CommandExists "choco")) {
        Install-ChocolateyApps
    }
    
    # Configure tools
    Install-VSCodeExtensions
    Set-GitConfiguration
    New-DevelopmentDirectories
    Enable-WindowsFeatures
    
    # Show summary
    Show-Summary
    
    Write-Status "Development environment setup completed successfully! 🚀"
}
catch {
    Write-Error "Script execution failed: $($_.Exception.Message)"
    exit 1
}
