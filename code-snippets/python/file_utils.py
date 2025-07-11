"""
File Operations Utility Functions
Description: Common file and directory operations for Python projects
Author: Script Repository
Version: 1.0
"""

import os
import shutil
import json
import csv
from pathlib import Path
from typing import List, Dict, Any, Optional


def ensure_directory(path: str) -> None:
    """
    Create directory if it doesn't exist.
    
    Args:
        path: Directory path to create
    """
    Path(path).mkdir(parents=True, exist_ok=True)


def safe_delete(path: str) -> bool:
    """
    Safely delete a file or directory.
    
    Args:
        path: Path to delete
        
    Returns:
        bool: True if deleted successfully, False otherwise
    """
    try:
        if os.path.isfile(path):
            os.remove(path)
        elif os.path.isdir(path):
            shutil.rmtree(path)
        return True
    except Exception as e:
        print(f"Error deleting {path}: {e}")
        return False


def copy_file_safe(src: str, dst: str, overwrite: bool = False) -> bool:
    """
    Safely copy a file with error handling.
    
    Args:
        src: Source file path
        dst: Destination file path
        overwrite: Whether to overwrite existing files
        
    Returns:
        bool: True if copied successfully, False otherwise
    """
    try:
        if not overwrite and os.path.exists(dst):
            print(f"Destination {dst} already exists. Use overwrite=True to replace.")
            return False
            
        ensure_directory(os.path.dirname(dst))
        shutil.copy2(src, dst)
        return True
    except Exception as e:
        print(f"Error copying {src} to {dst}: {e}")
        return False


def read_json_file(file_path: str) -> Optional[Dict[str, Any]]:
    """
    Read and parse a JSON file.
    
    Args:
        file_path: Path to JSON file
        
    Returns:
        Dict or None if error occurred
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error reading JSON file {file_path}: {e}")
        return None


def write_json_file(data: Dict[str, Any], file_path: str, indent: int = 2) -> bool:
    """
    Write data to a JSON file.
    
    Args:
        data: Data to write
        file_path: Output file path
        indent: JSON indentation level
        
    Returns:
        bool: True if written successfully, False otherwise
    """
    try:
        ensure_directory(os.path.dirname(file_path))
        with open(file_path, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=indent, ensure_ascii=False)
        return True
    except Exception as e:
        print(f"Error writing JSON file {file_path}: {e}")
        return False


def read_csv_file(file_path: str) -> Optional[List[Dict[str, str]]]:
    """
    Read a CSV file and return as list of dictionaries.
    
    Args:
        file_path: Path to CSV file
        
    Returns:
        List of dictionaries or None if error occurred
    """
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            return list(reader)
    except Exception as e:
        print(f"Error reading CSV file {file_path}: {e}")
        return None


def write_csv_file(data: List[Dict[str, str]], file_path: str) -> bool:
    """
    Write data to a CSV file.
    
    Args:
        data: List of dictionaries to write
        file_path: Output file path
        
    Returns:
        bool: True if written successfully, False otherwise
    """
    try:
        if not data:
            print("No data to write")
            return False
            
        ensure_directory(os.path.dirname(file_path))
        with open(file_path, 'w', newline='', encoding='utf-8') as f:
            writer = csv.DictWriter(f, fieldnames=data[0].keys())
            writer.writeheader()
            writer.writerows(data)
        return True
    except Exception as e:
        print(f"Error writing CSV file {file_path}: {e}")
        return False


def get_file_size(file_path: str) -> Optional[int]:
    """
    Get file size in bytes.
    
    Args:
        file_path: Path to file
        
    Returns:
        File size in bytes or None if error occurred
    """
    try:
        return os.path.getsize(file_path)
    except Exception as e:
        print(f"Error getting file size for {file_path}: {e}")
        return None


def list_files_recursive(directory: str, extension: str = None) -> List[str]:
    """
    List all files in directory recursively.
    
    Args:
        directory: Directory to search
        extension: File extension filter (e.g., '.py')
        
    Returns:
        List of file paths
    """
    files = []
    try:
        for root, dirs, filenames in os.walk(directory):
            for filename in filenames:
                if extension is None or filename.endswith(extension):
                    files.append(os.path.join(root, filename))
    except Exception as e:
        print(f"Error listing files in {directory}: {e}")
    
    return files


# Example usage
if __name__ == "__main__":
    # Test the utility functions
    test_dir = "test_files"
    ensure_directory(test_dir)
    
    # Test JSON operations
    test_data = {"name": "test", "version": "1.0", "items": [1, 2, 3]}
    json_file = os.path.join(test_dir, "test.json")
    
    if write_json_file(test_data, json_file):
        print(f"JSON file written to {json_file}")
        data = read_json_file(json_file)
        print(f"Read back: {data}")
    
    # Test CSV operations
    csv_data = [
        {"name": "Alice", "age": "30", "city": "New York"},
        {"name": "Bob", "age": "25", "city": "Los Angeles"}
    ]
    csv_file = os.path.join(test_dir, "test.csv")
    
    if write_csv_file(csv_data, csv_file):
        print(f"CSV file written to {csv_file}")
        data = read_csv_file(csv_file)
        print(f"Read back: {data}")
    
    # Clean up
    safe_delete(test_dir)
    print("Test completed and cleaned up")
