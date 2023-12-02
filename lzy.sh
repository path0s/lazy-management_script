#!/bin/bash

# LZY --VERSION 1.0 
# BY path0s
# ------------------------------------------------------------------------------------------------------------------------------------------------

show_credentials()
{
  echo "***** LZY --version 1.0 (by path0s) *****"
  sleep 2
} 

clears
show_credentials 
echo " "

if [ $# -ne 1 ]; then
  echo "ERROR!"
  echo "USAGE: ./lzy.sh </dir>"
  exit 1
fi

if [ ! -d "$1" ]; then
  echo "ERROR!"
  echo "$1 DOESN'T EXIST OR IT'S NOT A DIR!"
  exit 1
fi

cd "$1"

if [ -z "$(find "$1" -maxdepth 1 -type f)" ]; then
  echo "$1 DOESN'T CONTAIN ANY FILES TYPE!"
  echo "THE SCRIPT WILL NOT START!"
  exit 1
fi

# ----- MAIN -----
echo "$1 HAS FILES INSIDE..."
echo "THE SCRIPT IS RUNNING..."
echo " "
sleep 2

# creating folder called as today’s date
dirDate="$(date +%Y-%m-%d)"
mkdir -p "$dirDate"

# creating folder for each format of files
for file in "$1"/*; do
  if [ -f "$file" ]; then
    extension=$(echo "$file" | awk -F. '{print $NF}') 
    baseName=$(basename "$file" ".$extension")
    newFileName="$baseName"

    # Create the folder for the extension if it doesn't exist
    mkdir -p "$dirDate/$extension"

    # rename files if duplicated
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

echo "ALL FILES MOVE TO: $dirDate!"
# ----- END MAIN -----


# ----- REPORT -----
echo "Script executed at $(date)" > "$dirDate/report.txt"
echo "Number of directories created: $(ls -l "$dirDate" | grep "^d" | wc -l)" >> "$dirDate/report.txt"
echo "Number of files moved: $(find "$dirDate" -type f | wc -l)" >> "$dirDate/report.txt"
echo "Contents of each directory:" >> "$dirDate/report.txt"
ls -R "$dirDate" >> "$dirDate/report.txt"

echo "REPORT GENERATED AT $dirDate/report.txt"

echo " "
# ----- END REPORT -----

echo "THE SCRIPT HAS JUST FINISHED!"
show_credentials
