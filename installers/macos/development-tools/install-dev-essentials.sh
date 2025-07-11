#!/bin/bash

# macOS Development Tools Installation Script
# Description: Installs essential development tools for macOS using Homebrew
# Author: Script Repository
# Version: 1.0
# Requirements: macOS 11.0+, Administrator privileges
# Tools: Homebrew, Xcode Command Line Tools, Git, VS Code, Docker, Node.js, Python

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect architecture
detect_arch() {
    if [[ $(uname -m) == "arm64" ]]; then
        echo "Apple Silicon"
    else
        echo "Intel"
    fi
}

print_header "macOS Development Tools Installation"
print_status "Detected architecture: $(detect_arch)"
print_status "macOS version: $(sw_vers -productVersion)"

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only."
    exit 1
fi

# Install Xcode Command Line Tools
print_header "Installing Xcode Command Line Tools"
if ! xcode-select -p &> /dev/null; then
    print_status "Installing Xcode Command Line Tools..."
    xcode-select --install
    
    # Wait for installation to complete
    until xcode-select -p &> /dev/null; do
        sleep 5
        print_status "Waiting for Xcode Command Line Tools installation..."
    done
    
    print_status "Xcode Command Line Tools installed successfully"
else
    print_status "Xcode Command Line Tools already installed"
fi

# Install Homebrew
print_header "Installing Homebrew"
if ! command_exists brew; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    print_status "Homebrew installed successfully"
else
    print_status "Homebrew already installed"
    print_status "Updating Homebrew..."
    brew update
fi

# Install Git
print_header "Installing Git"
if ! command_exists git; then
    print_status "Installing Git..."
    brew install git
    print_status "Git installed successfully"
else
    print_status "Git already installed: $(git --version)"
fi

# Install Visual Studio Code
print_header "Installing Visual Studio Code"
if ! command_exists code; then
    print_status "Installing Visual Studio Code..."
    brew install --cask visual-studio-code
    print_status "Visual Studio Code installed successfully"
else
    print_status "Visual Studio Code already installed"
fi

# Install Docker Desktop
print_header "Installing Docker Desktop"
if ! command_exists docker; then
    print_status "Installing Docker Desktop..."
    brew install --cask docker
    print_status "Docker Desktop installed successfully"
    print_warning "Please start Docker Desktop manually from Applications folder"
else
    print_status "Docker already installed: $(docker --version)"
fi

# Install Node.js and npm
print_header "Installing Node.js"
if ! command_exists node; then
    print_status "Installing Node.js..."
    brew install node
    print_status "Node.js installed successfully"
    print_status "Node.js version: $(node --version)"
    print_status "npm version: $(npm --version)"
else
    print_status "Node.js already installed: $(node --version)"
fi

# Install Python 3
print_header "Installing Python 3"
if ! command_exists python3; then
    print_status "Installing Python 3..."
    brew install python@3.11
    print_status "Python 3 installed successfully"
else
    print_status "Python 3 already installed: $(python3 --version)"
fi

# Install additional development tools
print_header "Installing Additional Development Tools"

tools=(
    "wget"              # Download utility
    "curl"              # HTTP client
    "jq"                # JSON processor
    "tree"              # Directory listing
    "htop"              # System monitor
    "neofetch"          # System info
    "gh"                # GitHub CLI
    "mas"               # Mac App Store CLI
)

for tool in "${tools[@]}"; do
    if ! command_exists "$tool"; then
        print_status "Installing $tool..."
        brew install "$tool"
    else
        print_status "$tool already installed"
    fi
done

# Install development casks
print_header "Installing Development Applications"

casks=(
    "iTerm2"            # Terminal replacement
    "postman"           # API testing
    "tableplus"         # Database client
    "sourcetree"        # Git GUI
    "figma"             # Design tool
)

for cask in "${casks[@]}"; do
    cask_name=$(echo "$cask" | tr '[:upper:]' '[:lower:]')
    if ! brew list --cask | grep -q "^$cask_name$"; then
        print_status "Installing $cask..."
        brew install --cask "$cask_name"
    else
        print_status "$cask already installed"
    fi
done

# Install useful VS Code extensions
print_header "Installing VS Code Extensions"
if command_exists code; then
    extensions=(
        "ms-python.python"
        "ms-vscode.vscode-typescript-next"
        "bradlc.vscode-tailwindcss"
        "esbenp.prettier-vscode"
        "ms-vscode.vscode-json"
        "ms-vscode-remote.remote-containers"
        "github.copilot"
        "github.vscode-pull-request-github"
    )
    
    for extension in "${extensions[@]}"; do
        print_status "Installing VS Code extension: $extension"
        code --install-extension "$extension" --force
    done
fi

# Setup Git configuration (optional)
print_header "Git Configuration"
if ! git config --global user.name &> /dev/null; then
    read -p "Enter your Git username: " git_username
    read -p "Enter your Git email: " git_email
    
    git config --global user.name "$git_username"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    
    print_status "Git configured successfully"
else
    print_status "Git already configured for user: $(git config --global user.name)"
fi

# Create development directories
print_header "Creating Development Directories"
dev_dirs=(
    "$HOME/Development"
    "$HOME/Development/Projects"
    "$HOME/Development/Scripts"
    "$HOME/Development/Learning"
)

for dir in "${dev_dirs[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_status "Created directory: $dir"
    else
        print_status "Directory already exists: $dir"
    fi
done

# Final cleanup and verification
print_header "Cleanup and Verification"
brew cleanup
brew doctor

print_status "Development environment setup completed successfully!"

echo
print_header "🎉 Installation Summary"
echo "✅ Xcode Command Line Tools"
echo "✅ Homebrew package manager"
echo "✅ Git version control"
echo "✅ Visual Studio Code"
echo "✅ Docker Desktop"
echo "✅ Node.js and npm"
echo "✅ Python 3"
echo "✅ Essential command-line tools"
echo "✅ Development applications"
echo "✅ VS Code extensions"
echo "✅ Development directories"

echo
print_header "🚀 Next Steps"
echo "1. Start Docker Desktop from Applications"
echo "2. Sign in to GitHub in VS Code"
echo "3. Configure additional VS Code settings"
echo "4. Install project-specific dependencies"
echo "5. Start coding! 🎯"

echo
print_header "📚 Useful Commands"
echo "• brew search <package>     - Search for packages"
echo "• brew info <package>       - Get package information"  
echo "• brew list                 - List installed packages"
echo "• brew update && brew upgrade - Update all packages"
echo "• code <directory>          - Open directory in VS Code"
echo "• gh repo clone <repo>      - Clone GitHub repository"

print_status "Happy coding! 🚀"
