#!/bin/bash

# Git Account Switcher Menu for Linux/macOS
# Purpose: Interactive menu interface for Git account management
# Usage: ./git-switch-menu.sh
# Requirements: Bash shell, git-account-switcher.sh in same directory
# Author: Script Snippets Collection

# Color codes for output
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GIT_SWITCHER="$SCRIPT_DIR/git-account-switcher.sh"

# Function to print colored header
print_header() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║           Git Account Switcher Menu          ║${NC}"
    echo -e "${CYAN}║              Linux/macOS Version             ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
    echo
}

# Function to print menu options
print_menu() {
    echo -e "${BLUE}Please select an option:${NC}"
    echo
    echo -e "${YELLOW}1.${NC} Switch Git Account (Interactive Mode)"
    echo -e "${YELLOW}2.${NC} Quick Switch to Work Account"
    echo -e "${YELLOW}3.${NC} Quick Switch to Personal Account"
    echo -e "${YELLOW}4.${NC} Clear Git Credentials Only"
    echo -e "${YELLOW}5.${NC} Show Current Git Configuration"
    echo -e "${YELLOW}6.${NC} Show Help"
    echo -e "${YELLOW}7.${NC} Exit"
    echo
}

# Function to pause and wait for user input
pause() {
    echo
    read -p "Press Enter to continue..." -r
}

# Function to get current Git config
show_current_config() {
    echo -e "${GREEN}Current Git Configuration:${NC}"
    echo "Name:  $(git config --global user.name 2>/dev/null || echo 'Not set')"
    echo "Email: $(git config --global user.email 2>/dev/null || echo 'Not set')"
}

# Function to handle quick switch to work account
quick_switch_work() {
    echo -e "${GREEN}Quick Switch to Work Account${NC}"
    echo "Enter your work account details:"
    read -p "Work Email: " work_email
    read -p "Work Name: " work_name
    
    if [[ -n "$work_email" && -n "$work_name" ]]; then
        bash "$GIT_SWITCHER" --email "$work_email" --name "$work_name"
    else
        echo -e "${YELLOW}Both email and name are required${NC}"
    fi
}

# Function to handle quick switch to personal account
quick_switch_personal() {
    echo -e "${GREEN}Quick Switch to Personal Account${NC}"
    echo "Enter your personal account details:"
    read -p "Personal Email: " personal_email
    read -p "Personal Name: " personal_name
    
    if [[ -n "$personal_email" && -n "$personal_name" ]]; then
        bash "$GIT_SWITCHER" --email "$personal_email" --name "$personal_name"
    else
        echo -e "${YELLOW}Both email and name are required${NC}"
    fi
}

# Main menu loop
main() {
    # Check if git-account-switcher.sh exists
    if [[ ! -f "$GIT_SWITCHER" ]]; then
        echo -e "${YELLOW}Error: git-account-switcher.sh not found in $SCRIPT_DIR${NC}"
        echo "Please ensure git-account-switcher.sh is in the same directory as this script."
        exit 1
    fi
    
    # Make git-account-switcher.sh executable
    chmod +x "$GIT_SWITCHER" 2>/dev/null || true
    
    while true; do
        print_header
        show_current_config
        echo
        print_menu
        
        read -p "Enter your choice (1-7): " choice
        echo
        
        case $choice in
            1)
                echo -e "${GREEN}Starting Interactive Git Account Switch...${NC}"
                echo
                bash "$GIT_SWITCHER"
                pause
                ;;
            2)
                quick_switch_work
                pause
                ;;
            3)
                quick_switch_personal
                pause
                ;;
            4)
                echo -e "${GREEN}Clearing Git Credentials...${NC}"
                echo
                bash "$GIT_SWITCHER" --clear-credentials
                pause
                ;;
            5)
                echo -e "${GREEN}Current Git Configuration:${NC}"
                echo
                show_current_config
                pause
                ;;
            6)
                echo -e "${GREEN}Showing Help...${NC}"
                echo
                bash "$GIT_SWITCHER" --help
                pause
                ;;
            7)
                echo -e "${GREEN}Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "${YELLOW}Invalid option. Please enter a number between 1 and 7.${NC}"
                pause
                ;;
        esac
    done
}

# Run main function
main
