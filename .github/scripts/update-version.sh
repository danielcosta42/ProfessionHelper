#!/bin/bash
# Update version in all files
# Usage: ./update-version.sh 1.2.3

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Error: No version provided"
    exit 1
fi

echo "📝 Updating version to: $VERSION"

# Update ProfessionHelper.toc
echo "Updating ProfessionHelper.toc..."
sed -i "s/^## Version: .*/## Version: $VERSION/" ProfessionHelper.toc

# Update Core.lua
echo "Updating Core.lua..."
sed -i "s/PH\.version = \".*\"/PH.version = \"$VERSION\"/" Core.lua

# Update README.md badge
echo "Updating README.md..."
sed -i "s/version-[0-9]\+\.[0-9]\+\.[0-9]\+-blue/version-$VERSION-blue/" README.md

# Update credits popup version display
echo "Updating UI.lua..."
sed -i "s/\" .. PH\.L\[\"VERSION\"\] .. \" [0-9]\+\.[0-9]\+\.[0-9]\+/\" .. PH.L[\"VERSION\"] .. \" $VERSION/" UI.lua

echo "✅ Version updated to $VERSION in all files"
