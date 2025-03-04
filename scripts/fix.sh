#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <increment>"
    exit 1
fi

INCREMENT=$1
IMG_FILE="pstree.img"
TMP_JSON="pstree.json"
TMP_IMG="pstree_modified.img"

# Decode the image to JSON
crit decode -i "$IMG_FILE" -o "$TMP_JSON"

# Modify the JSON
jq --argjson inc "$INCREMENT" '
    .entries |= map(
        .pid += $inc |
        .pgid += $inc
    )
' "$TMP_JSON" > "$TMP_JSON.tmp" && mv "$TMP_JSON.tmp" "$TMP_JSON"

# Re-encode back to .img format
crit encode -i "$TMP_JSON" -o "$TMP_IMG"

# Replace original file
mv "$TMP_IMG" "$IMG_FILE"

# Clean up
rm -f "$TMP_JSON"

echo "Modified $IMG_FILE with increment $INCREMENT."


# Check if there are any fs-*.img files
FS_FILES=$(ls fs-*.img 2>/dev/null)

if [ -z "$FS_FILES" ]; then
    echo "No fs-*.img files found."
    exit 1
fi

# Extract the number from the filenames and process each file
for FS_FILE in $FS_FILES; do
    # Extract the number from the fs-*.img filename
    FILE_NUMBER=$(echo "$FS_FILE" | sed -E 's/^fs-([0-9]+)\.img/\1/')
    
    # Process each file using the extracted number
    echo "Processing fs file with number: $FILE_NUMBER"

    # Modify the files with incremented numbers
    for FILE_PREFIX in "fs" "pagemap" "ids" "mm"; do
        ORIGINAL_FILE="${FILE_PREFIX}-${FILE_NUMBER}.img"
        MODIFIED_FILE="${FILE_PREFIX}-$(( FILE_NUMBER + INCREMENT )).img"
        
        # Check if the original file exists and rename it
        if [ -f "$ORIGINAL_FILE" ]; then
            mv "$ORIGINAL_FILE" "$MODIFIED_FILE"
            echo "Renamed $ORIGINAL_FILE to $MODIFIED_FILE"
        else
            echo "Warning: $ORIGINAL_FILE not found"
        fi
    done
done

# Process core dump
ORIGINAL_CORE="core-$FILE_NUMBER.img"
MODIFIED_CORE="core-$(( FILE_NUMBER + INCREMENT )).img"

if [ -f "$ORIGINAL_CORE" ]; then
    crit show "$ORIGINAL_CORE" > core.json
    jq '.thread_core' core.json > thread_core.json
    crit show "$MODIFIED_CORE" > modified_core.json
    jq --slurpfile tc thread_core.json '.thread_core = $tc[0]' modified_core.json > modified_core_tmp.json
    crit encode -i modified_core_tmp.json -o "$MODIFIED_CORE"
    rm -f core.json thread_core.json modified_core.json modified_core_tmp.json
    echo "Copied thread_core from $ORIGINAL_CORE to $MODIFIED_CORE."
else
    echo "Warning: Original core file $ORIGINAL_CORE not found."
fi
