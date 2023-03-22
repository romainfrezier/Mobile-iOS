#!/bin/bash

cd ..;

# Run cloc to count lines of code
result=$(cloc Mobile-project-iOS --exclude-dir=.idea,-vscode --exclude-ext=json --git --md --quiet --hide-rate;)

# Remove the first and second line
result=$(echo "$result" | sed '1,2d')

# Replace "SUM:" with "Total"
result=$(echo "$result" | sed 's/SUM:/Total/')

# Get the current date and time
date_time=$(date +"%Y-%m-%d %H:%M:%S")

# Make the date_markdown variable
if [ ! -f Mobile-project-iOS/linecount.md ]; then
    date_markdown="# Date : $date_time\n\n---\n"
else
    date_markdown="\n---\n\n# Date : $date_time\n\n---\n"
fi

# Append the result to the date_markdown
result="$date_markdown$result"

# Append the result to the linecount.md file
echo -e "$result" >> Mobile-project-iOS/linecount.md
