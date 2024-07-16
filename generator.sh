#!/bin/bash

# Check the number of arguments
if [ "$#" -ne 1 ]; then
  echo "Incorrect number of arguments"
  echo "Usage: $0 <source_directory>"
  exit 1
fi

# Check if the argument is a directory
if [ ! -d "$1" ]; then
  echo "The provided argument is not a directory"
  echo "Usage: $0 <source_directory>"
  exit 1
fi

# Assign the argument to a variable
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