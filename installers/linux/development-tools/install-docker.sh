#!/bin/bash

# Docker Installation Script for Ubuntu/Debian
# Description: Installs Docker Engine and Docker Compose on Ubuntu/Debian systems
# Author: Script Repository
# Version: 1.0
# Requirements: Ubuntu 18.04+ or Debian 9+, sudo privileges

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# Check if script is run with sudo
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root. Run with sudo when prompted."
   exit 1
fi

print_status "Starting Docker installation..."

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    print_warning "Docker is already installed. Version: $(docker --version)"
    read -p "Do you want to continue with the installation? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Update package index
print_status "Updating package index..."
sudo apt-get update

# Install prerequisites
print_status "Installing prerequisites..."
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
print_status "Adding Docker's GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
print_status "Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again
print_status "Updating package index with Docker repository..."
sudo apt-get update

# Install Docker Engine
print_status "Installing Docker Engine..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Add current user to docker group
print_status "Adding user to docker group..."
sudo usermod -aG docker $USER

# Install Docker Compose
print_status "Installing Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Enable Docker service
print_status "Enabling Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Verify installation
print_status "Verifying Docker installation..."
sudo docker run hello-world

print_status "Docker installation completed successfully!"
print_warning "Please log out and log back in for group changes to take effect."
print_status "Docker version: $(docker --version)"
print_status "Docker Compose version: $(docker-compose --version)"

echo
print_status "Quick start commands:"
echo "  docker --version              # Check Docker version"
echo "  docker run hello-world        # Test Docker installation"
echo "  docker-compose --version      # Check Docker Compose version"
echo "  docker ps                     # List running containers"
