#!/bin/bash

# System Backup Script
# Description: Creates compressed backups of specified directories with rotation
# Author: Script Repository
# Version: 1.0
# Usage: ./backup.sh [config_file]

set -e

# Default configuration
BACKUP_DIRS="/home /etc /var/log"
BACKUP_DEST="/backup"
RETENTION_DAYS=7
COMPRESS=true
LOG_FILE="/var/log/backup.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
    log "INFO: $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
    log "WARNING: $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
    log "ERROR: $1"
}

# Load configuration file if provided
if [ $# -eq 1 ] && [ -f "$1" ]; then
    print_status "Loading configuration from $1"
    source "$1"
fi

# Validate configuration
if [ ! -d "$BACKUP_DEST" ]; then
    print_error "Backup destination $BACKUP_DEST does not exist"
    exit 1
fi

# Create timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_$TIMESTAMP"

print_status "Starting backup process..."
print_status "Backup destination: $BACKUP_DEST"
print_status "Retention period: $RETENTION_DAYS days"

# Create backup directory
BACKUP_PATH="$BACKUP_DEST/$BACKUP_NAME"
mkdir -p "$BACKUP_PATH"

# Function to backup a directory
backup_directory() {
    local src_dir="$1"
    local dest_name=$(basename "$src_dir")
    
    if [ ! -d "$src_dir" ]; then
        print_warning "Source directory $src_dir does not exist, skipping..."
        return
    fi
    
    print_status "Backing up $src_dir..."
    
    if [ "$COMPRESS" = true ]; then
        tar -czf "$BACKUP_PATH/${dest_name}.tar.gz" -C "$(dirname "$src_dir")" "$(basename "$src_dir")" 2>/dev/null
        if [ $? -eq 0 ]; then
            print_status "Successfully backed up $src_dir to ${dest_name}.tar.gz"
        else
            print_error "Failed to backup $src_dir"
        fi
    else
        cp -r "$src_dir" "$BACKUP_PATH/"
        if [ $? -eq 0 ]; then
            print_status "Successfully copied $src_dir"
        else
            print_error "Failed to copy $src_dir"
        fi
    fi
}

# Backup each directory
for dir in $BACKUP_DIRS; do
    backup_directory "$dir"
done

# Create backup manifest
MANIFEST_FILE="$BACKUP_PATH/backup_manifest.txt"
cat > "$MANIFEST_FILE" << EOF
Backup Information
==================
Date: $(date)
Hostname: $(hostname)
User: $(whoami)
Backup Directories: $BACKUP_DIRS
Compression: $COMPRESS
Backup Path: $BACKUP_PATH

Files in backup:
$(ls -la "$BACKUP_PATH")

System Information:
Disk Usage:
$(df -h)

Memory Usage:
$(free -h)
EOF

print_status "Backup manifest created: $MANIFEST_FILE"

# Calculate backup size
BACKUP_SIZE=$(du -sh "$BACKUP_PATH" | cut -f1)
print_status "Backup size: $BACKUP_SIZE"

# Cleanup old backups
if [ "$RETENTION_DAYS" -gt 0 ]; then
    print_status "Cleaning up backups older than $RETENTION_DAYS days..."
    find "$BACKUP_DEST" -name "backup_*" -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \; 2>/dev/null || true
    
    # Also clean up any orphaned compressed files
    find "$BACKUP_DEST" -name "backup_*.tar.gz" -type f -mtime +$RETENTION_DAYS -delete 2>/dev/null || true
fi

# Final status
REMAINING_BACKUPS=$(find "$BACKUP_DEST" -name "backup_*" -type d | wc -l)
print_status "Backup completed successfully!"
print_status "Total backups in destination: $REMAINING_BACKUPS"
print_status "Latest backup: $BACKUP_PATH"

# Send notification (if mail is available)
if command -v mail &> /dev/null; then
    echo "Backup completed on $(hostname) at $(date). Size: $BACKUP_SIZE" | mail -s "Backup Completed" root@localhost 2>/dev/null || true
fi

log "Backup process completed successfully"
