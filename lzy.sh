#!/bin/bash

# LZY --VERSION 0.1 
# BY path0s
# ------------------------------------------------------------------------------------------------------------------------------------------------
# The script will contain a main folder named with the date on which the script will be executed (format date: yyyy-mm-dd) and 
# will contain n folders how many are the formats of the only files inside the main folder and 
# will transfer the corresponding files to the corresponding format folders

# Finally it generates a report file (called report.txt) that illustrates the information of the script and the listing of the newly created folders
# ------------------------------------------------------------------------------------------------------------------------------------------------

# ----- FUNCTIONS PART -----
show_credentials()
{
  echo "***** LZY --version 0.1 (by path0s) *****"
  sleep 2
}
# ----- END FUNCTIONS PART ----- 

# clear the display
clear

# ----- CREDENTIALS PART -----
show_credentials 

echo " "
# ----- END CREDENTIALS PART -----


# ----- CHECKS PART -----
# check if the number of argument is only 1
if [ $# -ne 1 ]; then
  echo "ERROR!"
  echo "USAGE: ./lzy.sh </dir>"
  exit 1
fi

# check if the only arguments is a directory
if [ ! -d "$1" ]; then
  echo "ERROR!"
  echo "$1 DOESN'T EXIST OR IT'S NOT A DIR!"
  exit 1
fi

# going into the directory passed as argument
cd "$1"

# check if dir is empty
if [ -z "$(find "$1" -maxdepth 1 -type f)" ]; then
  echo "$1 DOESN'T CONTAIN ANY FILES TYPE!"
  echo "THE SCRIPT WILL NOT START!"
  exit 1
fi
# ***** END CHECKS PART *****


# ***** MAIN PART *****
echo "$1 HAS FILE INSIDE..."
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
# ----- END MAIN PART -----


# ----- REPORT PART -----
echo "Script executed at $(date)" > "$dirDate/report.txt"
echo "Number of directories created: $(ls -l "$dirDate" | grep "^d" | wc -l)" >> "$dirDate/report.txt"
echo "Number of files moved: $(find "$dirDate" -type f | wc -l)" >> "$dirDate/report.txt"
echo "Contents of each directory:" >> "$dirDate/report.txt"
ls -R "$dirDate" >> "$dirDate/report.txt"

echo "REPORT GENERATED AT $dirDate/report.txt"

echo " "
# ----- END REPORT PART -----

echo "THE SCRIPT HAS JUST FINISHED!"
show_credentials
