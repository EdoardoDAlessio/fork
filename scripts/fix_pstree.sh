

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
        .pgid += $inc |
        .threads |= [.[$inc]]  # Keep only the index element
        )
' "$TMP_JSON" > "$TMP_JSON.tmp" && mv "$TMP_JSON.tmp" "$TMP_JSON"

# Re-encode back to .img format
crit encode -i "$TMP_JSON" -o "$TMP_IMG"

# Replace original file
mv "$TMP_IMG" "$IMG_FILE"

# Clean up
rm -f "$TMP_JSON"

echo "Modified $IMG_FILE with increment $INCREMENT."