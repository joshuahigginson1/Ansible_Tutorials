#!/bin/bash

# This script counts the number of files with a particular extension on the machine.

# When running modules, ansible will pass the module a file name as an argument.
# The file stores any arguments for the module.

# Check if the file exists...
if [ -f "${1:-""}" ]; then
  arg_file=$1  # Set variable arg_file equal to the file name.

  # Scan for any line containing "ext=" and store the third field to console.
  file_ext="$(awk -F= '/ext=/ {print $2}' ${arg_file})"
fi

# Check if the file_ext was populated. If not, set the default to "py".
if [ -z "$file_ext" ]; then
  file_ext="py"
fi

# Find all files with the supplied file extension, and count them.
file_count="$(find . -type f -name \*.$file_ext | wc -l | grep [0-9]* )"

# Print the file count and extension, formatted in JSON to the console.
echo "{\FileCount\": ${file_count}, \"FileExt\": \"{file_ext}\" }"





