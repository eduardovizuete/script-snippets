# Linux App Installers

This directory contains installation scripts for various Linux applications, organized by category.

## Directory Structure

- **development-tools/**: Programming tools, IDEs, and development environments
- **system-utilities/**: System tools, monitoring, and utility applications
- **media-entertainment/**: Media players, streaming, and entertainment apps
- **productivity/**: Office suites, note-taking, and productivity applications
- **security-tools/**: Security software, VPNs, and protection tools
- **server-software/**: Web servers, databases, and server applications
- **desktop-apps/**: GUI applications and desktop environments

## Usage

1. Make scripts executable: `chmod +x script_name.sh`
2. Run with appropriate permissions: `./script_name.sh` or `sudo ./script_name.sh`
3. Follow any prompts or instructions in the script

## Script Standards

All scripts should:
- Include a header comment explaining the purpose
- Check for existing installations
- Handle errors gracefully
- Provide user feedback during installation
- Support major Linux distributions when possible

## Supported Distributions

Scripts are tested on:
- Ubuntu/Debian
- CentOS/RHEL/Fedora
- Arch Linux
- openSUSE

## Contributing

When adding new scripts:
1. Place in the appropriate category directory
2. Use descriptive filenames
3. Include proper error handling
4. Test on multiple distributions if possible
5. Update this README if adding new categories
