# macOS Installation Scripts

Installation scripts for macOS applications and development tools using Homebrew, mas-cli, and direct installers.

## 📦 Prerequisites

Most scripts require **Homebrew**. Install it first:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

For App Store applications, install **mas-cli**:
```bash
brew install mas
```

## 📁 Categories

### 🛠️ Development Tools (`development-tools/`)
- **Xcode and Command Line Tools**
- **IDEs**: VS Code, IntelliJ IDEA, WebStorm, Android Studio
- **Editors**: Sublime Text, Atom, Vim/Neovim
- **Version Control**: Git, GitHub Desktop, SourceTree
- **Containers**: Docker Desktop, Podman
- **Runtimes**: Node.js, Python, Java, Go, Rust
- **Databases**: PostgreSQL, MySQL, MongoDB, Redis
- **Terminal Tools**: iTerm2, Hyper, Fig

### 📊 Productivity (`productivity/`)
- **Office Suites**: Microsoft Office, LibreOffice
- **Note Taking**: Notion, Obsidian, Bear, Markdown editors
- **Communication**: Slack, Discord, Zoom, Teams
- **File Management**: The Unarchiver, AppCleaner
- **Password Managers**: 1Password, Bitwarden
- **Task Management**: Todoist, Things 3

### 🔧 System Utilities (`system-utilities/`)
- **System Monitoring**: Activity Monitor alternatives, htop, btop
- **Disk Management**: Disk Utility alternatives, DaisyDisk
- **Network Tools**: Wireshark, Network Scanner
- **System Maintenance**: CleanMyMac, Onyx
- **Window Management**: Rectangle, Magnet, Amethyst

### 🎵 Media & Entertainment (`media-entertainment/`)
- **Media Players**: VLC, IINA, Plex
- **Image Editors**: GIMP, Krita, Pixelmator
- **Video Editors**: DaVinci Resolve, HandBrake
- **Audio Tools**: Audacity, Logic Pro X
- **Streaming**: OBS Studio, Streamlabs

### 🔒 Security Tools (`security-tools/`)
- **VPNs**: NordVPN, ExpressVPN, Wireguard
- **Antivirus**: Malwarebytes, ClamAV
- **Network Security**: Little Snitch, LuLu
- **Encryption**: VeraCrypt, GPG Suite

## 🚀 Usage Examples

### Install Single Application
```bash
# Make script executable
chmod +x install-vscode.sh

# Run the script
./install-vscode.sh
```

### Install Development Environment
```bash
# Install complete development setup
./install-dev-essentials.sh
```

### Batch Installation
```bash
# Install multiple applications from a list
./batch-install.sh app-list.txt
```

## 📋 Script Features

All macOS installation scripts include:
- **Homebrew integration** for maximum compatibility
- **App Store integration** using mas-cli when applicable
- **Architecture detection** (Intel vs Apple Silicon)
- **Existing installation checks**
- **Error handling and rollback**
- **Progress feedback**

## 🍎 macOS-Specific Considerations

### System Permissions
- Some applications require **System Preferences > Security & Privacy** approval
- **Gatekeeper** may block unsigned applications
- **SIP (System Integrity Protection)** restrictions

### Installation Methods Priority
1. **Homebrew Cask** (preferred for most GUI apps)
2. **Homebrew Formula** (for CLI tools)
3. **Mac App Store** (for apps available there)
4. **Direct Download** (.dmg/.pkg files)

### Apple Silicon Compatibility
- Scripts detect architecture and install appropriate versions
- Most modern applications support Universal Binary
- Legacy applications may run through Rosetta 2

## 🔧 Common Installation Patterns

### Homebrew Cask
```bash
brew install --cask application-name
```

### Mac App Store
```bash
mas install app-id
```

### Direct Download
```bash
curl -L -o installer.dmg "download-url"
hdiutil attach installer.dmg
# Copy application or run installer
hdiutil detach /Volumes/AppName
```

## 🚨 Troubleshooting

### Permission Issues
```bash
# Fix Homebrew permissions
sudo chown -R $(whoami) $(brew --prefix)/*
```

### Gatekeeper Issues
```bash
# Allow specific app
sudo spctl --add /Applications/AppName.app
# Or disable Gatekeeper temporarily (not recommended)
sudo spctl --master-disable
```

### App Store Sign-in
```bash
# Sign in to App Store for mas-cli
mas signin user@example.com
```

## 📱 App Store Integration

Many scripts integrate with the Mac App Store for applications available there:
- Automatic App Store sign-in verification
- Bundle ID resolution for application names
- Update management through System Preferences

## 🤝 Contributing

When adding macOS installation scripts:
1. Test on both Intel and Apple Silicon Macs
2. Prefer Homebrew when possible
3. Include proper error handling
4. Check for Xcode Command Line Tools when needed
5. Document any manual steps required
