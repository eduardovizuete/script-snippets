#!/bin/bash

# Git Account Switcher for Linux/macOS
# Purpose: Automate switching between different Git accounts with validation and credential management
# Usage: ./git-account-switcher.sh [--email EMAIL] [--name NAME] [--clear-credentials] [--help]
# Requirements: Git CLI, bash shell
# Author: Script Snippets Collection
# Version: 2.0

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Configuration
readonly SCRIPT_VERSION="2.0"
readonly SCRIPT_NAME="Git Account Switcher"

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} ✅ $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} ⚠️  $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} ❌ $1"
}

print_header() {
    echo -e "${CYAN}=== $SCRIPT_NAME v$SCRIPT_VERSION${NC} ${YELLOW}===== $1 ===${NC}"
}

# Function to validate email format
validate_email() {
    local email="$1"
    local email_regex="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    
    if [[ $email =~ $email_regex ]]; then
        return 0
    else
        return 1
    fi
}

# Function to validate name (non-empty, reasonable length)
validate_name() {
    local name="$1"
    
    if [[ -z "$name" ]]; then
        print_error "Name cannot be empty"
        return 1
    fi
    
    if [[ ${#name} -lt 2 ]]; then
        print_error "Name must be at least 2 characters long"
        return 1
    fi
    
    if [[ ${#name} -gt 50 ]]; then
        print_error "Name must be less than 50 characters long"
        return 1
    fi
    
    return 0
}

# Function to clear Git credentials from various credential stores
clear_git_credentials() {
    print_info "Clearing Git credentials from credential stores..."
    
    # Clear macOS Keychain (if available)
    if command -v security >/dev/null 2>&1; then
        print_info "Clearing macOS Keychain Git credentials..."
        # Clear GitHub credentials
        security delete-internet-password -s github.com 2>/dev/null || true
        security delete-internet-password -s github.com -r "http" 2>/dev/null || true
        security delete-internet-password -s github.com -r "https" 2>/dev/null || true
        # Clear GitLab credentials
        security delete-internet-password -s gitlab.com 2>/dev/null || true
        security delete-internet-password -s gitlab.com -r "http" 2>/dev/null || true
        security delete-internet-password -s gitlab.com -r "https" 2>/dev/null || true
    fi
    
    # Clear Linux credential stores
    if command -v gnome-keyring-daemon >/dev/null 2>&1; then
        print_info "Clearing GNOME Keyring Git credentials..."
        # Clear stored passwords using secret-tool if available
        if command -v secret-tool >/dev/null 2>&1; then
            secret-tool clear protocol https server github.com 2>/dev/null || true
            secret-tool clear protocol https server gitlab.com 2>/dev/null || true
        fi
    fi
    
    # Clear Git credential cache
    if git config --global credential.helper | grep -q cache; then
        print_info "Clearing Git credential cache..."
        git credential-cache exit 2>/dev/null || true
    fi
    
    # Clear Git credential store file (if it exists)
    local git_credentials_file="$HOME/.git-credentials"
    if [[ -f "$git_credentials_file" ]]; then
        print_warning "Found Git credentials file: $git_credentials_file"
        read -p "Do you want to clear it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            > "$git_credentials_file"
            print_success "Git credentials file cleared"
        fi
    fi
    
    print_success "Git credentials cleared from available stores"
}

# Function to get current Git configuration
get_current_config() {
    local current_name current_email
    current_name=$(git config --global user.name 2>/dev/null || echo "Not set")
    current_email=$(git config --global user.email 2>/dev/null || echo "Not set")
    
    echo -e "${CYAN}=== Current Git Configuration ===${NC}"
    echo "Name:  $current_name"
    echo "Email: $current_email"
}

# Function to set Git configuration
set_git_config() {
    local email="$1"
    local name="$2"
    
    print_info "Setting Git configuration..."
    
    # Set global Git configuration
    git config --global user.email "$email"
    git config --global user.name "$name"
    
    print_success "Git account switched successfully!"
    print_info "Name: $name"
    print_info "Email: $email"
}

# Function to get user input interactively
get_user_input() {
    local email name
    
    echo
    print_info "Please enter your Git account information:"
    
    # Get email with validation
    while true; do
        read -p "Enter email address: " email
        
        if validate_email "$email"; then
            break
        else
            print_error "Invalid email format. Please enter a valid email address."
        fi
    done
    
    # Get name with validation
    while true; do
        read -p "Enter full name: " name
        
        if validate_name "$name"; then
            break
        else
            print_error "Invalid name. Please enter a valid name (2-50 characters)."
        fi
    done
    
    echo "$email|$name"
}

# Function to show help
show_help() {
    cat << EOF
$SCRIPT_NAME v$SCRIPT_VERSION

DESCRIPTION:
    Automate switching between different Git accounts with validation and credential management.
    Supports both interactive and parameter-driven execution modes.

USAGE:
    $0 [OPTIONS]
    $0 --email EMAIL --name NAME
    $0 --clear-credentials
    $0 --help

OPTIONS:
    --email EMAIL           Set Git email address
    --name NAME            Set Git user name
    --clear-credentials    Clear stored Git credentials from system stores
    --help                 Show this help message

EXAMPLES:
    # Interactive mode
    $0

    # Parameter mode
    $0 --email "user@example.com" --name "John Doe"

    # Clear credentials only
    $0 --clear-credentials

    # Show help
    $0 --help

SUPPORTED PLATFORMS:
    - Linux (with GNOME Keyring support)
    - macOS (with Keychain support)

REQUIREMENTS:
    - Git CLI installed and accessible
    - Bash shell
    - Optional: secret-tool (Linux), security (macOS)

SECURITY NOTES:
    - Always validates email format before setting
    - Clears credential stores to prevent account mixing
    - Uses secure input methods
    - No hardcoded credentials

EOF
}

# Main function
main() {
    local email="" name="" clear_only=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --email)
                email="$2"
                shift 2
                ;;
            --name)
                name="$2"
                shift 2
                ;;
            --clear-credentials)
                clear_only=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                print_info "Use --help for usage information"
                exit 1
                ;;
        esac
    done
    
    # Check if Git is installed
    if ! command -v git >/dev/null 2>&1; then
        print_error "Git is not installed or not in PATH"
        exit 1
    fi
    
    # If only clearing credentials
    if [[ "$clear_only" == true ]]; then
        print_header "Clearing Credentials"
        clear_git_credentials
        echo
        get_current_config
        exit 0
    fi
    
    # Determine execution mode
    if [[ -n "$email" && -n "$name" ]]; then
        # Parameter mode
        print_header "Parameter Mode"
        
        # Validate inputs
        if ! validate_email "$email"; then
            print_error "Invalid email format: $email"
            exit 1
        fi
        
        if ! validate_name "$name"; then
            print_error "Invalid name: $name"
            exit 1
        fi
        
    elif [[ -z "$email" && -z "$name" ]]; then
        # Interactive mode
        print_header "Interactive Mode"
        
        # Show current configuration
        get_current_config
        
        # Get user input
        local user_input
        user_input=$(get_user_input)
        email=$(echo "$user_input" | cut -d'|' -f1)
        name=$(echo "$user_input" | cut -d'|' -f2)
        
    else
        # Partial parameters provided
        print_error "Both --email and --name must be provided when using parameter mode"
        print_info "Use --help for usage information"
        exit 1
    fi
    
    echo
    print_header "Switching Account"
    
    # Clear credentials before switching
    clear_git_credentials
    
    echo
    # Set Git configuration
    set_git_config "$email" "$name"
    
    echo
    get_current_config
    
    echo
    print_success "Git account switch completed successfully!"
}

# Run main function with all arguments
main "$@"
