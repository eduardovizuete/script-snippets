# Multi-Platform Installation Scripts

This directory contains installation scripts organized by operating system and application category.

## 🖥️ Operating Systems

### 🐧 Linux (`linux/`)
Installation scripts for various Linux distributions:
- **development-tools/**: IDEs, editors, compilers, and development frameworks
- **system-utilities/**: System monitoring, file management, and utility tools
- **media-entertainment/**: Media players, streaming apps, and entertainment software
- **productivity/**: Office suites, note-taking apps, and productivity tools
- **security-tools/**: Security scanners, VPNs, and protection software
- **server-software/**: Web servers, databases, and server applications
- **desktop-apps/**: GUI applications and desktop environments

### 🍎 macOS (`macos/`)
Installation scripts for macOS systems using Homebrew, mas-cli, and direct installers:
- **development-tools/**: Xcode, VS Code, Docker, Node.js, Python, etc.
- **productivity/**: Office suites, note-taking, and productivity applications
- **system-utilities/**: System monitoring, file management, and utility tools
- **media-entertainment/**: Media players, streaming, and entertainment apps
- **security-tools/**: Security software, VPNs, and protection tools

### 🪟 Windows (`windows/`)
Installation scripts for Windows using PowerShell, Chocolatey, and Winget:
- **development-tools/**: Visual Studio, VS Code, Git, Docker, etc.
- **productivity/**: Office suites, productivity applications
- **system-utilities/**: System tools and utilities

## 📦 Package Managers Used

### Linux
- **apt** (Ubuntu/Debian)
- **yum/dnf** (CentOS/RHEL/Fedora)
- **pacman** (Arch Linux)
- **zypper** (openSUSE)
- **snap** (Universal packages)
- **flatpak** (Universal packages)

### macOS
- **Homebrew** (Primary package manager)
- **mas-cli** (Mac App Store CLI)
- **Direct downloads** (.dmg, .pkg installers)

### Windows
- **Chocolatey** (Community package manager)
- **Winget** (Official Windows package manager)
- **PowerShell** (Direct installers)
- **Scoop** (Command-line installer)

## 🚀 Usage Guidelines

### Before Running Scripts
1. **Read the script**: Understand what it will install
2. **Check requirements**: Ensure your system meets prerequisites
3. **Backup important data**: Always backup before major installations
4. **Test in safe environment**: Test scripts in VMs when possible

### Running Scripts

#### Linux/macOS
```bash
# Make executable
chmod +x script_name.sh

# Run script
./script_name.sh

# Or run with sudo if required
sudo ./script_name.sh
```

#### Windows (PowerShell)
```powershell
# Set execution policy (if needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run script
.\script_name.ps1
```

## 🛡️ Security Considerations

- **Review scripts** before execution
- **Check signatures** for downloaded content
- **Use official repositories** when possible
- **Verify checksums** for direct downloads
- **Run with minimal privileges** when possible

## 📝 Script Standards

All scripts should include:
- Header with description, author, version, and requirements
- Error handling and user feedback
- Check for existing installations
- Support for dry-run mode when applicable
- Proper logging and cleanup

## 🤝 Contributing

When adding new installation scripts:
1. Place in appropriate OS and category directory
2. Follow naming convention: `install-[app-name].sh/ps1`
3. Include comprehensive error handling
4. Test on multiple versions of target OS
5. Update relevant documentation

## 🔗 Cross-Platform Applications

For applications available on multiple platforms, create separate scripts in each OS directory rather than trying to create universal scripts. This ensures optimal installation methods for each platform.

## 📊 Supported Distributions/Versions

### Linux
- Ubuntu 18.04, 20.04, 22.04, 24.04
- Debian 10, 11, 12
- CentOS 7, 8, Stream
- RHEL 8, 9
- Fedora 35+
- Arch Linux (rolling)
- openSUSE Leap 15.x, Tumbleweed

### macOS
- macOS 11 (Big Sur) and later
- Intel and Apple Silicon support

### Windows
- Windows 10 (version 1903+)
- Windows 11
- Windows Server 2019, 2022
