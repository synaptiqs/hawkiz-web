#!/usr/bin/env python3
"""
Script to check and update requirements.txt with latest package versions.
Run this periodically to keep dependencies up to date.
"""

import subprocess
import re
import sys
from pathlib import Path

def get_latest_version(package_name):
    """Get the latest version of a package from PyPI."""
    try:
        # Remove extras like [standard] from package name
        base_package = re.sub(r'\[.*?\]', '', package_name).strip()
        
        result = subprocess.run(
            [sys.executable, '-m', 'pip', 'index', 'versions', base_package],
            capture_output=True,
            text=True,
            timeout=10
        )
        
        if result.returncode == 0:
            # Parse the output to get the latest version
            lines = result.stdout.split('\n')
            for line in lines:
                if 'Available versions:' in line or 'LATEST:' in line:
                    # Extract version numbers
                    versions = re.findall(r'\d+\.\d+\.\d+', line)
                    if versions:
                        return versions[0]
        return None
    except Exception as e:
        print(f"Error checking {package_name}: {e}")
        return None

def update_requirements_file(requirements_path):
    """Update requirements.txt with latest versions."""
    requirements_path = Path(requirements_path)
    
    if not requirements_path.exists():
        print(f"Error: {requirements_path} not found")
        return False
    
    # Read current requirements
    with open(requirements_path, 'r') as f:
        lines = f.readlines()
    
    updated_lines = []
    updated_count = 0
    
    print("Checking for updates...")
    print("-" * 50)
    
    for line in lines:
        line = line.strip()
        
        # Skip empty lines and comments
        if not line or line.startswith('#'):
            updated_lines.append(line + '\n')
            continue
        
        # Parse package name and version
        # Handle formats like: package==version, package>=version, package[extras]==version
        match = re.match(r'^([^=<>!]+?)(==|>=|<=|>|<|!=)(.+)$', line)
        
        if match:
            package_spec = match.group(1).strip()
            operator = match.group(2)
            current_version = match.group(3).strip()
            
            # Get base package name (remove extras)
            base_package = re.sub(r'\[.*?\]', '', package_spec).strip()
            
            # Get latest version
            latest_version = get_latest_version(base_package)
            
            if latest_version:
                # Check if update is needed
                if operator == '==' and current_version != latest_version:
                    new_line = f"{package_spec}=={latest_version}"
                    updated_lines.append(new_line + '\n')
                    print(f"✓ {package_spec}: {current_version} → {latest_version}")
                    updated_count += 1
                else:
                    updated_lines.append(line + '\n')
            else:
                # Keep original if we can't check
                updated_lines.append(line + '\n')
                print(f"⚠ {package_spec}: Could not check version (keeping {current_version})")
        else:
            # Keep lines that don't match the pattern
            updated_lines.append(line + '\n')
    
    # Write updated requirements
    if updated_count > 0:
        with open(requirements_path, 'w') as f:
            f.writelines(updated_lines)
        print("-" * 50)
        print(f"✓ Updated {updated_count} package(s)")
        return True
    else:
        print("-" * 50)
        print("✓ All packages are up to date!")
        return False

if __name__ == '__main__':
    # Default to requirements.txt in the same directory as this script
    script_dir = Path(__file__).parent
    requirements_file = script_dir / 'requirements.txt'
    
    if len(sys.argv) > 1:
        requirements_file = Path(sys.argv[1])
    
    update_requirements_file(requirements_file)

