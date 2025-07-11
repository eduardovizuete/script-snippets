# Contributing to Script Snippets Repository

Thank you for your interest in contributing to this repository! This guide will help you get started.

## How to Contribute

### 1. Types of Contributions
- **Scripts**: Linux installation scripts, automation tools
- **Code Snippets**: Reusable code in various programming languages
- **AI Prompts**: Custom instructions and prompts for AI tools
- **Templates**: Project and configuration templates
- **Documentation**: Improvements to existing docs or new guides

### 2. Before You Start
- Check existing issues and pull requests to avoid duplicates
- Read the relevant README files in each directory
- Ensure your contribution fits the repository's purpose and structure

### 3. Contribution Process

#### For New Scripts or Code
1. **Fork** the repository
2. **Create a branch** with a descriptive name:
   ```bash
   git checkout -b feature/add-nginx-installer
   ```
3. **Follow the guidelines** for your contribution type (see below)
4. **Test thoroughly** on appropriate systems
5. **Document** your changes
6. **Submit a pull request** with a clear description

#### For Documentation Updates
1. Make your changes
2. Ensure formatting is consistent
3. Check for spelling and grammar
4. Submit a pull request

### 4. Guidelines by Category

#### Linux Installation Scripts
- **Location**: Place in appropriate `linux-installers/` subdirectory
- **Naming**: Use descriptive names like `install-docker.sh`
- **Header**: Include purpose, author, version, and requirements
- **Error Handling**: Implement proper error checking and user feedback
- **Compatibility**: Test on major distributions when possible
- **Safety**: Check for existing installations, provide uninstall options

**Template for Installation Scripts:**
```bash
#!/bin/bash

# Application Name Installation Script
# Description: Brief description of what this installs
# Author: Your Name
# Version: 1.0
# Requirements: Ubuntu 18.04+, sudo privileges

set -e

# Add your installation logic here
```

#### Code Snippets
- **Location**: Place in appropriate `code-snippets/` language directory
- **Documentation**: Include clear comments and usage examples
- **Dependencies**: List any required libraries or tools
- **Testing**: Include test cases or example usage
- **Naming**: Use descriptive filenames that indicate functionality

#### AI Prompts and Instructions
- **Testing**: Verify prompts work with target AI systems
- **Documentation**: Explain the purpose and expected outcomes
- **Examples**: Include sample inputs and outputs when helpful
- **Specificity**: Be clear and specific in instructions

#### Automation Scripts
- **Safety**: Include dry-run options and confirmation prompts
- **Logging**: Implement proper logging and error reporting
- **Configuration**: Make scripts configurable through files or variables
- **Documentation**: Explain setup requirements and usage

### 5. Code Style and Standards

#### General Requirements
- Use clear, descriptive names for files and functions
- Include comprehensive comments for complex logic
- Follow language-specific style guides
- Implement proper error handling
- Test on multiple environments when applicable

#### Bash Scripts
- Use `#!/bin/bash` shebang
- Use `set -e` for error handling
- Include colored output for better UX
- Implement help/usage functions
- Check prerequisites before execution

#### Python Code
- Follow PEP 8 style guide
- Use type hints where appropriate
- Include docstrings for functions and classes
- Handle exceptions gracefully
- Use virtual environments for testing

### 6. Testing Requirements
- Test scripts on clean systems when possible
- Verify scripts work on multiple OS versions
- Include both positive and negative test cases
- Document testing procedures
- Test with different user permissions

### 7. Documentation Standards
- Update relevant README files
- Use clear, concise language
- Include usage examples
- Document any prerequisites
- Keep formatting consistent

### 8. Pull Request Guidelines

#### PR Title Format
```
Category: Brief description

Examples:
- Linux Installer: Add PostgreSQL installation script
- Code Snippet: Python database connection utility
- AI Prompt: ChatGPT code review instructions
- Documentation: Update backup script usage guide
```

#### PR Description Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New script/code snippet
- [ ] Bug fix
- [ ] Documentation update
- [ ] Enhancement to existing code

## Testing
- [ ] Tested on Ubuntu 20.04
- [ ] Tested on CentOS 8
- [ ] Code tested with unit tests
- [ ] Documentation reviewed

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No sensitive information included
```

### 9. Security Guidelines
- **Never** include passwords, API keys, or sensitive data
- Use environment variables for configuration
- Validate user inputs
- Follow security best practices for each language
- Review scripts for potential security issues

### 10. Getting Help
- Check existing documentation first
- Open an issue for questions or clarifications
- Tag maintainers in complex PRs
- Be patient and respectful in communications

## Recognition
Contributors will be acknowledged in release notes and the main README file.

Thank you for helping make this repository better! 🎉
