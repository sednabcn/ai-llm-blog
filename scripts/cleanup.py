#!/usr/bin/env python3
import os
import glob
import shutil
import argparse

def cleanup_directory(directory, remove_patterns, move_patterns, rubbish_dir):
    """
    Comprehensive directory cleanup:
    1. Removes files matching remove_patterns
    2. Moves files matching move_patterns to rubbish_dir
    
    Args:
        directory (str): The root directory to clean up
        remove_patterns (list): Patterns of files to delete
        move_patterns (list): Patterns of files to move to rubbish directory
        rubbish_dir (str): Destination directory for moved files
    
    Returns:
        tuple: (list of removed files, list of moved files)
    """
    if not os.path.isdir(directory):
        print(f"Error: Directory '{directory}' does not exist")
        return [], []
    
    # Ensure rubbish directory exists
    os.makedirs(rubbish_dir, exist_ok=True)
    
    removed_files = []
    moved_files = []
    
    # Walk through the directory tree
    for root, _, _ in os.walk(directory):
        # Process files to remove
        for pattern in remove_patterns:
            full_pattern = os.path.join(root, pattern)
            matched_files = glob.glob(full_pattern)
            matched_files.extend(glob.glob(full_pattern, recursive=True))
            
            for file_path in set(matched_files):
                if os.path.isfile(file_path):
                    try:
                        os.remove(file_path)
                        removed_files.append(file_path)
                        print(f"Removed: {file_path}")
                    except Exception as e:
                        print(f"Error removing {file_path}: {e}")
        
        # Process files to move
        for pattern in move_patterns:
            full_pattern = os.path.join(root, pattern)
            matched_files = glob.glob(full_pattern)
            matched_files.extend(glob.glob(full_pattern, recursive=True))
            
            for file_path in set(matched_files):
                if os.path.isfile(file_path):
                    try:
                        file_name = os.path.basename(file_path)
                        dest_path = os.path.join(rubbish_dir, file_name)
                        
                        # Handle file name collisions
                        counter = 1
                        while os.path.exists(dest_path):
                            name, ext = os.path.splitext(file_name)
                            dest_path = os.path.join(rubbish_dir, f"{name}_{counter}{ext}")
                            counter += 1
                        
                        shutil.move(file_path, dest_path)
                        moved_files.append((file_path, dest_path))
                        print(f"Moved: {file_path} -> {dest_path}")
                    except Exception as e:
                        print(f"Error moving {file_path}: {e}")
    
    return removed_files, moved_files

def main():
    parser = argparse.ArgumentParser(description="Directory cleanup utility")
    parser.add_argument("--dir", default="/home/agagora/Downloads/GITHUB/ai-llm-blog", 
                      help="Directory to clean up")
    parser.add_argument("--rubbish", default="/home/agagora/Documents/DEVELOPOR/JEKYLL/rubbish", 
                      help="Directory to move files to")
    args = parser.parse_args()
    
    # Define patterns
    remove_patterns = ['*.*~', '.yml_*', '*~', '.*~', '.scss~', '.*.*~']
    move_patterns = ["*.copy", "*.txt", "main.scssX", "main.scss1*", "main.scss2*"]
    
    # Run the cleanup
    removed_files, moved_files = cleanup_directory(
        args.dir, remove_patterns, move_patterns, args.rubbish
    )
    
    # Print summary
    print("\n===== CLEANUP SUMMARY =====")
    print(f"Removed {len(removed_files)} files")
    print(f"Moved {len(moved_files)} files to {args.rubbish}")
    
    if removed_files:
        print("\nRemoved files:")
        for file in removed_files:
            print(f"- {file}")
    
    if moved_files:
        print("\nMoved files:")
        for source, dest in moved_files:
            print(f"- {source} -> {dest}")

if __name__ == "__main__":
    main()
