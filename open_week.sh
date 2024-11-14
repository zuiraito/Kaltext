#!/bin/bash

# Pass threw data
day=$(echo "$1" | cut -d. -f1)
month=$(echo "$1" | cut -d. -f2)
year=$(echo "$1" | cut -d. -f3)

# Set defaults if not given
if [ -z "$day" ]; then
    day=$(date +%-d)
else
    day="$day"
fi
if [ -z "$month" ]; then
    month=$(date +%-m)
else
    month="$month"
fi
if [ -z "$year" ]; then
    year=$(date +%Y)
else
    year="20$year"
fi

# Format the date as yyyy-mm-dd for date parsing
formatted_date="${year}-${month}-${day}"

# Calculate the week number
week_number=$(date -d "$formatted_date" +%V)

# Format the filename as {year}w{week}
filename="${year: -2}w${week_number}"

# Determine the weekday in German for the given day
weekday=$(date -d "$formatted_date" +%A)
case "$weekday" in
  "Monday") weekday="Montag" ;;
  "Tuesday") weekday="Dienstag" ;;
  "Wednesday") weekday="Mittwoch" ;;
  "Thursday") weekday="Donnerstag" ;;
  "Friday") weekday="Freitag" ;;
  "Saturday") weekday="Samstag" ;;
  "Sunday") weekday="Sonntag" ;;
  *) weekday="" ;;
esac

# Create the weekday string with the date
weekday_string="$weekday $day.$month."

# Calculate the length of the box (based on the length of the weekday string)
box_length=$(( ${#weekday_string} + 2 ))

# Create the formatted weekday with the date in a box
horizontal_line=$(printf '─%.0s' $(seq 1 $box_length))
formatted_weekday_l1="┌$horizontal_line┐"
formatted_weekday_l2="│ $weekday_string │"
formatted_weekday_l3="└$horizontal_line┘"

# Check if the formatted weekday already exists in the file
if grep -q "$weekday" "$filename"; then
    # If found, open Vim at the corresponding weekday line
    vim +"/$weekday" "$filename"
else
    # If not found, append the formatted weekday at the end and open Vim
    echo "$formatted_weekday_l1" >> "$filename"
    echo "$formatted_weekday_l2" >> "$filename"
    echo "$formatted_weekday_l3" >> "$filename"
    if grep -q "$weekday" "$filename"; then
        # If found, open Vim at the corresponding weekday line
        vim +"/$weekday" "$filename"
    else
        echo "something did not work. :("
    fi
fi
