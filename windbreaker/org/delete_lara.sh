#!/usr/bin/env bash

# Find and delete directories with the prefix "lara-" in the current directory
for dir in lara-*; do
  if [ -d "$dir" ]; then
    rm -rf "$dir"
    echo "Deleted directory: $dir"
  fi
done

