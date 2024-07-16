#!/bin/bash

# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
  echo "Incorrect number of arguments"
  echo "Usage: $0 <source_directory> or $0 <file1.c> <file2.h> ..."
  exit 1
fi

# Check if the first argument is a directory
if [ -d "$1" ]; then
  SOURCE_DIR="$1"
  # Check for .c and .h files in the directory
  C_FILES=$(find "$SOURCE_DIR" -maxdepth 1 -name '*.c')
  H_FILES=$(find "$SOURCE_DIR" -maxdepth 1 -name '*.h')

  if [ -z "$C_FILES" ]; then
    echo "No .c files found in the directory"
    exit 1
  fi

  if [ -z "$H_FILES" ]; then
    echo "No .h files found in the directory"
    exit 1
  fi

  echo "Source directory: $SOURCE_DIR"
  echo ".c files found:"
  echo "$C_FILES"
  echo ".h files found:"
  echo "$H_FILES"
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
      echo "Ignoring unrecognized file: $FILE"
    fi
  done

  if [ ${#C_FILES[@]} -eq 0 ]; then
    echo "No .c files provided"
    exit 1
  fi

  if [ ${#H_FILES[@]} -eq 0 ]; then
    echo "No .h files provided"
    exit 1
  fi

  echo ".c files found:"
  for FILE in "${C_FILES[@]}"; do
    echo "$FILE"
  done

  echo ".h files found:"
  for FILE in "${H_FILES[@]}"; do
    echo "$FILE"
  done
fi

# Further processing can be added here
