#!/bin/bash

# LZY -- VERSION 1.0
# By path0s
# ---------------------------------------------------------------------------

# Function to display script credentials
show_credentials() {
  echo "***** LZY -- version 1.0 (by path0s) *****"
  sleep 2
}

# Clear the terminal
clear
show_credentials
echo " "

# Check the number of arguments passed to the script
if [ $# -ne 1 ]; then
  echo "ERROR!"
  echo "USAGE: ./lzy.sh </directory>"
  exit 1
fi

# Check if the specified directory exists
if [ ! -d "$1" ]; then
  echo "ERROR!"
  echo "$1 DOESN'T EXIST OR IT'S NOT A DIRECTORY!"
  exit 1
fi

cd "$1"

# Check if there are files inside the directory
if [ -z "$(find "$1" -maxdepth 1 -type f)" ]; then
  echo "$1 DOESN'T CONTAIN ANY FILE TYPES!"
  echo "THE SCRIPT WILL NOT START!"
  exit 1
fi

# ------------------- MAIN ---------------------
echo "$1 CONTAINS FILES..."
echo "THE SCRIPT IS RUNNING..."
echo " "
sleep 2

# Create a folder with today's date
dirDate="$(date +%Y-%m-%d)"
mkdir -p "$dirDate"

# Create a folder for each format of files
for file in "$1"/*; do
  if [ -f "$file" ]; then
    extension=$(echo "$file" | awk -F. '{print $NF}')
    baseName=$(basename "$file" ".$extension")
    newFileName="$baseName"

    # Create the folder for the extension if it doesn't exist
    mkdir -p "$dirDate/$extension"

    # Rename files if duplicated
    counter=1
    while [ -f "$dirDate/$extension/$newFileName.$extension" ]; do
      newFileName="$baseName-$counter"
      ((counter++))
    done
    fileRenamed="$dirDate/$extension/$newFileName.$extension"

    echo "MOVING $file TO $fileRenamed"
    mv "$file" "$fileRenamed"
  fi
done

echo " "

echo "ALL FILES MOVED TO: $dirDate!"

echo "Script executed at $(date)" > "$dirDate/report.txt"
echo "Number of directories created: $(ls -l "$dirDate" | grep "^d" | wc -l)" >> "$dirDate/report.txt"
echo "Number of files moved: $(find "$dirDate" -type f | wc -l)" >> "$dirDate/report.txt"
echo "Contents of each directory:" >> "$dirDate/report.txt"
ls -R "$dirDate" >> "$dirDate/report.txt"

echo "REPORT GENERATED AT $dirDate/report.txt"

echo " "

echo "THE SCRIPT HAS JUST FINISHED!"
show_credentials
