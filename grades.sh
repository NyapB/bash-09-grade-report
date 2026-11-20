#!/bin/bash

# Check if a file argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 FILE.csv" >&2
    exit 1
fi

CSV_FILE="$1"

# Check if the file exists and is readable
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: File '$CSV_FILE' not found." >&2
    exit 1
fi

# Print the table header
printf "%4s %-16s %4s %4s %4s %4s %6s %s\n" "RANK" "NAME" "HTML" "CSS" "BASH" "GIT" "AVG" "MENTION"

# Initialize counters and sum trackers
line_num=0
skipped_count=0
total_valid_students=0
class_total_score=0

# Create a temporary file for sorting
tmp_file=$(mktemp)

# Read the CSV file line by line
while IFS=',' read -r raw_name raw_html raw_css raw_bash raw_git || [ -n "$raw_name" ]; do
    ((line_num++))

    # Skip the header line
    if [ $line_num -eq 1 ]; then
        continue
    fi

    # Clean data: Remove Windows carriage returns (\r) and trailing/leading spaces
    name=$(echo "$raw_name" | tr -d '\r' | xargs)
    html=$(echo "$raw_html" | tr -d '\r' | xargs)
    css=$(echo "$raw_css" | tr -d '\r' | xargs)
    bash=$(echo "$raw_bash" | tr -d '\r' | xargs)
    git=$(echo "$raw_git" | tr -d '\r' | xargs)

    # Validation: Check for missing name
    if [ -z "$name" ]; then
        echo "Warning: Line $line_num skipped (missing name)" >&2
        ((skipped_count++))
        continue
    fi

    # Validation: Check for missing scores
    if [ -z "$html" ] || [ -z "$css" ] || [ -z "$bash" ] || [ -z "$git" ]; then
        echo "Warning: Line $line_num skipped (missing score)" >&2
        ((skipped_count++))
        continue
    fi

    # Validation: Ensure scores contain only digits (whole numbers) and are within range
    invalid_score=0
    for score in "$html" "$css" "$bash" "$git"; do
        if ! [[ "$score" =~ ^[0-9]+$ ]]; then
            echo "Warning: Line $line_num skipped (score '$score' is not a valid whole number)" >&2
            invalid_score=1
            break
        # Force Base-10 (10#) to handle leading zeros like 08 and 09 without octal crashes
        elif (( 10#$score > 20 )); then
            echo "Warning: Line $line_num skipped (score $score exceeds maximum of 20)" >&2
            invalid_score=1
            break
        fi
    done

    if [ $invalid_score -eq 1 ]; then
        ((skipped_count++))
        continue
    fi

    # Calculations: Force base-10 arithmetic to safely sum up scores
    total_score=$((10#$html + 10#$css + 10#$bash + 10#$git))
    
    # Calculate precise floating point average with awk
    avg=$(awk "BEGIN {printf \"%.2f\", $total_score / 4}")

    # Determine mention based on scaled total thresholds
    if (( total_score >= 64 )); then
        mention="Très bien"
    elif (( total_score >= 56 )); then
        mention="Bien"
    elif (( total_score >= 48 )); then
        mention="Assez bien"
    elif (( total_score >= 40 )); then
        mention="Passable"
    else
        mention="Échec"
    fi

    # Save to staging file structured for reverse numerical sort
    echo "$avg|$name|$html|$css|$bash|$git|$mention" >> "$tmp_file"

    # Track metrics for final class average calculation
    class_total_score=$((class_total_score + total_score))
    ((total_valid_students++))

done < "$CSV_FILE"

# Sort data, assign dynamic rank, and format table output layout
rank=0
sort -t'|' -k1,1 -rn "$tmp_file" | while IFS='|' read -r avg name html css bash git mention; do
    ((rank++))
    printf "%4d %-16s %4s %4s %4s %4s %6s %s\n" "$rank" "$name" "$html" "$css" "$bash" "$git" "$avg" "$mention"
done

# Clean up temporary storage footprint
rm -f "$tmp_file"

# Adjusted dashed separator to match the ~60-character table width perfectly
echo "------------------------------------------------------------"
if [ $total_valid_students -gt 0 ]; then
    class_avg=$(awk "BEGIN {printf \"%.2f\", ($class_total_score / $total_valid_students) / 4}")
    echo "Class average: $class_avg"
else
    echo "Class average: 0.00"
fi
echo "Skipped $skipped_count invalid lines (see warnings above)"
