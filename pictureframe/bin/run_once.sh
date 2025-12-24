#!/bin/bash

# 1. Define the search query (e.g., 'boost:popular' or 'in:digitalart')
# specific search: q=in:digitalart+landscape
FEED_URL="https://backend.deviantart.com/rss.xml?q=boost:popular+traditional/sketch/pencil/graphite/ink/monochrome"

echo "Fetching art list..."

# 2. Fetch RSS, extract image URLs, and pick a random one
# We use grep to find the media:content url, cut to extract it, and shuf to pick one.
IMAGE_URL=$(curl -s "$FEED_URL" | \
grep -o '<media:content url="[^"]*"' | \
cut -d'"' -f2 | \
shuf -n 1)

if [ -z "$IMAGE_URL" ]; then
    echo "Error: Could not find any images. DeviantArt might be rate-limiting you."
    exit 1
fi

echo "Found random image: $IMAGE_URL"
echo "Downloading..."

# 3. Download the file
curl "$IMAGE_URL" -o image.jpg

echo "Displaying..."

/mnt/us/extensions/MRInstaller/bin/KHF/fbink --clear
/mnt/us/extensions/MRInstaller/bin/KHF/fbink -g file=image.jpg,w=-2,halign=center,valign=center,dither --flatten

echo "Done!"

