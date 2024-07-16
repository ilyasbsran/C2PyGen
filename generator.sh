#!/bin/bash

# Function to log messages with a timestamp
log_message() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" | tee -a "$log_file"
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
    log_message "Build and log directories already exist."
  else
    # Try to create the log directory
    mkdir -p "$log_dir"
    if [ $? -eq 0 ]; then
      log_message "Log directory created successfully."
    else
      echo "Error: Failed to create log directory." >&2  # Direct output to stderr as logging might not be available
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
      log_message "Log directory created successfully."
    else
      echo "Error: Failed to create log directory." >&2  # Direct output to stderr as logging might not be available
      exit 1
    fi
    log_message "Build directory created successfully."
  else
    echo "Error: Failed to create build directory." >&2  # Direct output to stderr as logging might not be available
    exit 1
  fi
fi

# Further processing can be added here


# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
  log_message "Incorrect number of arguments"
  log_message "Usage: $0 <source_directory> or $0 <file1.c> <file2.h> ..."
  exit 1
fi

# Check if the first argument is a directory
if [ -d "$1" ]; then
  SOURCE_DIR="$1"
  # Check for .c and .h files in the directory
  C_FILES=$(find "$SOURCE_DIR" -maxdepth 1 -name '*.c')
  H_FILES=$(find "$SOURCE_DIR" -maxdepth 1 -name '*.h')

  if [ -z "$C_FILES" ]; then
    log_message "No .c files found in the directory"
    exit 1
  fi

  if [ -z "$H_FILES" ]; then
    log_message "No .h files found in the directory"
    exit 1
  fi

  log_message "Source directory: $SOURCE_DIR"
  log_message ".c files found:"
  log_message "$C_FILES"
  log_message ".h files found:"
  log_message "$H_FILES"
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
      log_message "Ignoring unrecognized file: $FILE"
    fi
  done

  if [ ${#C_FILES[@]} -eq 0 ]; then
    log_message "No .c files provided"
    exit 1
  fi

  if [ ${#H_FILES[@]} -eq 0 ]; then
    log_message "No .h files provided"
    exit 1
  fi

  log_message ".c files found:"
  for FILE in "${C_FILES[@]}"; do
    log_message "$FILE"
  done

  log_message ".h files found:"
  for FILE in "${H_FILES[@]}"; do
    log_message "$FILE"
  done
fi