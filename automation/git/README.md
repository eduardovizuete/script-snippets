# Git Automation Tools

This directory contains automation tools for Git version control management.

## 🔧 Available Scripts

### Git Account Switcher (`git-account-switcher.ps1`)

A flexible PowerShell script to automate switching between different Git accounts with user input validation and credential management.

#### ✨ Features
- **Interactive Mode**: Prompts for username and email with current values as defaults
- **Parameter Mode**: Accept username/email as command-line parameters
- **Email Validation**: Ensures proper email format before configuration
- **Credential Management**: Option to clear Windows stored credentials
- **Current Config Display**: Shows current Git configuration
- **Error Handling**: Comprehensive validation and error reporting

#### 📋 Parameters

| Parameter | Type | Description | Required | Default |
|-----------|------|-------------|----------|---------|
| `-Action` | String | Action to perform: `switch`, `show`, `clear` | No | `switch` |
| `-Name` | String | Git username to set | No | Prompted if not provided |
| `-Email` | String | Git email address to set | No | Prompted if not provided |
| `-ClearCredentials` | Switch | Clear Windows credentials after switching | No | `False` |
| `-Interactive` | Switch | Force interactive mode even with parameters | No | `False` |

#### 🚀 Usage Examples

##### Interactive Mode (Recommended)
```powershell
# Interactive switching - prompts for user input with current values as defaults
.\git-account-switcher.ps1

# Force interactive mode even when parameters are provided
.\git-account-switcher.ps1 -Interactive
```

##### Parameter Mode
```powershell
# Switch with specific name and email
.\git-account-switcher.ps1 -Name "John Smith" -Email "john.smith@company.com"

# Switch with only name (will prompt for email)
.\git-account-switcher.ps1 -Name "Jane Doe"

# Switch with only email (will prompt for name)
.\git-account-switcher.ps1 -Email "developer@example.com"
```

##### Configuration Management
```powershell
# Show current Git configuration
.\git-account-switcher.ps1 -Action show

# Clear stored Git credentials only
.\git-account-switcher.ps1 -Action clear

# Switch account and clear stored credentials
.\git-account-switcher.ps1 -Name "Dev User" -Email "dev@company.com" -ClearCredentials
```

#### 🖥️ Quick Access Menu (`git-switch.bat`)

A Windows batch file providing a menu-driven interface for the PowerShell script.

```cmd
# Run the interactive menu
.\git-switch.bat
```

**Menu Options:**
1. Switch Git Account (Interactive)
2. Show Current Git Account
3. Clear Git Credentials  
4. Switch with Manual Input
5. Show Usage Guide

#### 📝 Use Cases

##### Scenario 1: Developer with Multiple Accounts
```powershell
# Switch to work account
.\git-account-switcher.ps1 -Name "WorkUser" -Email "work@company.com"

# Switch to personal account
.\git-account-switcher.ps1 -Name "PersonalUser" -Email "personal@gmail.com"
```

##### Scenario 2: First-Time Git Setup
```powershell
# Interactive setup for new machine
.\git-account-switcher.ps1
# Will prompt for both name and email
```

##### Scenario 3: Troubleshooting Authentication
```powershell
# Clear credentials and switch account
.\git-account-switcher.ps1 -Name "User" -Email "user@domain.com" -ClearCredentials
```

##### Scenario 4: Quick Status Check
```powershell
# Check current configuration
.\git-account-switcher.ps1 -Action show
```

#### 🛡️ Security Features

- **No Hardcoded Data**: All account information comes from user input
- **Email Validation**: Uses regex to validate email format
- **Credential Clearing**: Safely removes stored Windows credentials
- **Input Validation**: Prevents empty usernames and invalid emails
- **Error Handling**: Graceful handling of Git command failures

#### ⚙️ Requirements

- **Windows PowerShell 5.1+** or **PowerShell Core 6+**
- **Git** installed and accessible from command line
- **Execution Policy** set to allow script execution:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

#### 🔧 Installation

1. Download the scripts to your automation directory
2. Set PowerShell execution policy if needed
3. Run the script directly or use the batch file for menu access

#### 📊 What Gets Modified

- **Global Git Configuration**: `git config --global user.name` and `git config --global user.email`
- **Windows Credential Manager**: Git-related stored credentials (when using `-ClearCredentials`)
- **Git Credential Helper**: May be unset during credential clearing

#### 🚨 Important Notes

- The script modifies **global** Git configuration, affecting all repositories
- Credential clearing affects **all Git services** stored in Windows Credential Manager
- Interactive mode shows current values as defaults for easy switching
- Email validation uses standard regex pattern for format checking
- The script handles both complete and partial parameter sets gracefully

#### 🔍 Troubleshooting

##### Common Issues

**Script Execution Policy Error:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Git Command Not Found:**
- Ensure Git is installed and in your PATH
- Restart PowerShell after Git installation

**Credential Clearing Issues:**
- Run PowerShell as Administrator for full credential access
- Some enterprise environments may restrict credential management

##### Verification Commands

```powershell
# Check current Git configuration
git config --global user.name
git config --global user.email

# List stored credentials
cmdkey /list | findstr git

# Test Git access
git ls-remote https://github.com/user/repo.git
```

## 🤝 Contributing

When adding new Git automation tools:
1. Follow the same error handling patterns
2. Include comprehensive parameter validation
3. Provide both interactive and parameter modes
4. Add proper documentation with examples
5. Test on multiple Windows versions
6. Ensure security best practices
