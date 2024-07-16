#!/bin/bash

# Function to log messages with a timestamp, log level, and line number
log_message() {
  local log_level=$1
  local log_message=$2
  local caller_info=$(caller 0)
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $log_level - ${caller_info} - $log_message" | tee -a "$log_file"
}

# Define the build and log directories
build_dir="build"
log_dir="$build_dir/log"
timestamp=$(date +'%Y-%m-%d_%H-%M-%S')
log_file="$log_dir/build_script_$timestamp.log"

# Check if the build directory exists
if [ -d "$build_dir" ]; then
  # If build directory exists, check if the log directory exists
  if [ -d "$log_dir" ]; then
    log_message "INFO" "Build and log directories already exist."
  else
    # Try to create the log directory
    mkdir -p "$log_dir"
    if [ $? -eq 0 ]; then
      log_message "INFO" "Log directory created successfully."
    else
      log_message "ERROR" "Failed to create log directory."
      exit 1
    fi
  fi
else
  # Try to create the build directory
  mkdir -p "$build_dir"
  if [ $? -eq 0 ]; then
    # Try to create the log directory after creating the build directory
    mkdir -p "$log_dir"
    if [ $? -eq 0 ]; then
      log_message "INFO" "Log directory created successfully."
    else
      log_message "ERROR" "Failed to create log directory."
      exit 1
    fi
    log_message "INFO" "Build directory created successfully."
  else
    log_message "ERROR" "Failed to create build directory."
    exit 1
  fi
fi

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
  log_message "ERROR" "Incorrect number of arguments"
  log_message "ERROR" "Usage: $0 <source_directory> or $0 <file1.c> <file2.h> ..."
  exit 1
fi

# Check if the first argument is a directory
if [ -d "$1" ]; then
  SOURCE_DIR="$1"
  # Check for .c and .h files in the directory
  C_FILES=$(find "$SOURCE_DIR" -maxdepth 1 -name '*.c')
  H_FILES=$(find "$SOURCE_DIR" -maxdepth 1 -name '*.h')

  if [ -z "$C_FILES" ]; then
    log_message "ERROR" "No .c files found in the directory"
    exit 1
  fi

  if [ -z "$H_FILES" ]; then
    log_message "ERROR" "No .h files found in the directory"
    exit 1
  fi

  log_message "INFO" "Source directory: $SOURCE_DIR"
  log_message "INFO" ".c files found:"
  log_message "INFO" "$C_FILES"
  log_message "INFO" ".h files found:"
  log_message "INFO" "$H_FILES"
else
  # Treat all arguments as individual files
  C_FILES=()
  H_FILES=()

  for FILE in "$@"; do
    if [[ "$FILE" == *.c ]]; then
      C_FILES+=("$FILE")
    elif [[ "$FILE" == *.h ]]; then
      H_FILES+=("$FILE")
    else
      log_message "WARNING" "Ignoring unrecognized file: $FILE"
    fi
  done

  if [ ${#C_FILES[@]} -eq 0 ]; then
    log_message "ERROR" "No .c files provided"
    exit 1
  fi

  if [ ${#H_FILES[@]} -eq 0 ]; then
    log_message "ERROR" "No .h files provided"
    exit 1
  fi

  log_message "INFO" ".c files found:"
  for FILE in "${C_FILES[@]}"; do
    log_message "INFO" "$FILE"
  done

  log_message "INFO" ".h files found:"
  for FILE in "${H_FILES[@]}"; do
    log_message "INFO" "$FILE"
  done
fi

# Ensure the src directory exists
if [ -d "$src_dir" ]; then
  log_message "INFO" "Source directory already exists. Clearing contents."
  rm -rf "$src_dir"/*
else
  # Try to create the src directory
  mkdir -p "$src_dir"
  if [ $? -eq 0 ]; then
    log_message "INFO" "Source directory created successfully."
  else
    log_message "ERROR" "Failed to create source directory."
    exit 1
  fi
fi

# Copy .c and .h files to the src directory
for FILE in "${C_FILES[@]}" "${H_FILES[@]}"; do
  cp "$FILE" "$src_dir/"
  if [ $? -eq 0 ]; then
    log_message "INFO" "Copied $FILE to $src_dir"
  else
    log_message "ERROR" "Failed to copy $FILE to $src_dir"
    exit 1
  fi
done

# Verify that the files were copied successfully
for FILE in "${C_FILES[@]}" "${H_FILES[@]}"; do
  BASENAME=$(basename "$FILE")
  if [ -e "$src_dir/$BASENAME" ]; then
    log_message "INFO" "$BASENAME copied successfully to $src_dir"
  else
    log_message "ERROR" "Failed to verify $BASENAME in $src_dir"
    exit 1
  fi
done