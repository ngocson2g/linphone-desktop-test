#!/bin/bash
cd /home/son/Project/softphoneZlink_desktop/linphone-desktop/external/linphone-sdk
grep -E 'path =|url =' .gitmodules | paste - - | while read path_line url_line; do
  path=$(echo "$path_line" | awk '{print $3}')
  url=$(echo "$url_line" | awk '{print $3}')
  repo_name=$(basename "$url")
  
  if echo "$url" | grep -q "github.com"; then
    new_url="$url"
  else
    new_url="https://github.com/BelledonneCommunications/$repo_name"
  fi
  
  if [ -d "$path" ] && [ -z "$(ls -A $path)" ]; then
    echo "Cloning $new_url into $path..."
    rm -rf "$path"
    git clone --depth 1 "$new_url" "$path"
    rm -rf "$path/.git"
  elif [ ! -d "$path" ]; then
    echo "Cloning $new_url into $path..."
    git clone --depth 1 "$new_url" "$path"
    rm -rf "$path/.git"
  else
    echo "Skipping $path (already populated)"
  fi
done
