# Windows Installation Scripts

PowerShell scripts for installing applications on Windows using Chocolatey, Winget, and direct installers.

## 📦 Prerequisites

### Chocolatey (Recommended)
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### Windows Package Manager (Winget)
Winget comes pre-installed on Windows 10 1809+ and Windows 11. Update from Microsoft Store if needed.

### PowerShell Execution Policy
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## 📁 Categories

### 🛠️ Development Tools (`development-tools/`)
- **IDEs**: Visual Studio, VS Code, IntelliJ IDEA
- **Version Control**: Git, GitHub Desktop, TortoiseGit
- **Containers**: Docker Desktop, Podman Desktop
- **Runtimes**: Node.js, Python, .NET, Java
- **Databases**: SQL Server, PostgreSQL, MySQL, MongoDB
- **Terminal Tools**: Windows Terminal, PowerShell Core

### 📊 Productivity (`productivity/`)
- **Office Suites**: Microsoft Office, LibreOffice
- **Communication**: Microsoft Teams, Slack, Discord
- **Note Taking**: Notion, Obsidian, OneNote
- **File Management**: 7-Zip, WinRAR, Everything
- **Password Managers**: Bitwarden, 1Password

### 🔧 System Utilities (`system-utilities/`)
- **System Monitoring**: Process Explorer, Resource Monitor
- **Disk Management**: TreeSize, WinDirStat
- **Network Tools**: Wireshark, Advanced IP Scanner
- **System Maintenance**: CCleaner, Defraggler
- **Window Management**: PowerToys, AltTab

### 🎵 Media & Entertainment (`media-entertainment/`)
- **Media Players**: VLC, MPC-HC, Spotify
- **Image Editors**: GIMP, Paint.NET, IrfanView
- **Video Editors**: DaVinci Resolve, HandBrake
- **Gaming**: Steam, Epic Games, GOG Galaxy

### 🔒 Security Tools (`security-tools/`)
- **Antivirus**: Windows Defender, Malwarebytes
- **VPN**: NordVPN, ExpressVPN, ProtonVPN
- **Firewall**: Windows Firewall, Comodo
- **Password Tools**: KeePass, Bitwarden

## 🚀 Usage Examples

### Install Single Application
```powershell
# Run PowerShell script
.\install-vscode.ps1

# Or use Chocolatey directly
choco install vscode -y

# Or use Winget
winget install Microsoft.VisualStudioCode
```

### Install Development Environment
```powershell
# Install complete development setup
.\install-dev-essentials.ps1
```

### Batch Installation
```powershell
# Install from package list
.\batch-install.ps1 -PackageList "app-list.txt"
```

## 📋 Script Features

All Windows installation scripts include:
- **Multiple package manager support** (Chocolatey, Winget, direct)
- **Administrator privilege checking**
- **Existing installation detection**
- **Error handling and logging**
- **Progress indication**
- **Cleanup and verification**

## 🪟 Windows-Specific Considerations

### Execution Policy
Scripts may require changing PowerShell execution policy:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Administrator Privileges
Many installations require administrator privileges. Scripts will prompt for elevation when needed.

### Windows Defender
Windows Defender may flag scripts. Add exclusions if necessary:
```powershell
Add-MpPreference -ExclusionPath "C:\Scripts"
```

### Package Manager Comparison

| Feature | Chocolatey | Winget | Direct |
|---------|------------|--------|--------|
| Package Count | 9000+ | 6000+ | Custom |
| Installation Speed | Fast | Fast | Variable |
| Dependency Management | Yes | Limited | No |
| Update Management | Yes | Yes | Manual |
| Community | Large | Growing | N/A |

## 🔧 Common Installation Patterns

### Chocolatey
```powershell
# Install package
choco install package-name -y

# Install multiple packages
choco install package1 package2 package3 -y

# Upgrade all packages
choco upgrade all -y
```

### Winget
```powershell
# Install package
winget install Publisher.PackageName

# Search for packages
winget search "package name"

# List installed packages
winget list
```

### Direct Installation
```powershell
# Download and install
$url = "https://example.com/installer.exe"
$output = "$env:TEMP\installer.exe"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process -FilePath $output -ArgumentList "/S" -Wait
Remove-Item $output
```

## 🚨 Troubleshooting

### Package Manager Issues
```powershell
# Refresh Chocolatey
choco upgrade chocolatey

# Reset Winget
winget source reset
```

### PowerShell Issues
```powershell
# Check execution policy
Get-ExecutionPolicy

# Reset PowerShell
Remove-Module PowerShellGet -Force
Install-Module PowerShellGet -Force
```

### Permission Issues
```powershell
# Run as administrator
Start-Process PowerShell -Verb RunAs
```

## 🎯 Best Practices

1. **Always test scripts** in a VM first
2. **Create system restore points** before major installations
3. **Use package managers** when possible for easier updates
4. **Keep installation logs** for troubleshooting
5. **Verify checksums** for direct downloads

## 🤝 Contributing

When adding Windows installation scripts:
1. Test on multiple Windows versions (10, 11)
2. Support both Chocolatey and Winget when possible
3. Include proper error handling and logging
4. Check for administrator privileges when required
5. Provide both silent and interactive installation options
