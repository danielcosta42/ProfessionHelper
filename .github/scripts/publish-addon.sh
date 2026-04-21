#!/bin/bash
# Create package and publish to platforms
# Usage: ./publish-addon.sh 1.2.3

VERSION=$1

if [ -z "$VERSION" ]; then
    echo "Error: No version provided"
    exit 1
fi

echo "📦 Creating release package for version $VERSION"

# Create package directory
mkdir -p package/ProfessionHelper

# Copy addon files
echo "Copying files..."
cp *.lua package/ProfessionHelper/ 2>/dev/null || true
cp *.toc package/ProfessionHelper/
cp LICENSE package/ProfessionHelper/
cp README.md package/ProfessionHelper/
cp CHANGELOG.md package/ProfessionHelper/
cp -r Locales package/ProfessionHelper/
cp -r Data package/ProfessionHelper/

# Create ZIP
echo "Creating ZIP archive..."
cd package
zip -r ../ProfessionHelper-v${VERSION}.zip ProfessionHelper/
cd ..

# Verify package
if [ ! -f "ProfessionHelper-v${VERSION}.zip" ]; then
    echo "❌ Failed to create package"
    exit 1
fi

SIZE=$(stat -c%s "ProfessionHelper-v${VERSION}.zip" 2>/dev/null || stat -f%z "ProfessionHelper-v${VERSION}.zip")
SIZE_KB=$((SIZE / 1024))
echo "✅ Package created: ProfessionHelper-v${VERSION}.zip (${SIZE_KB} KB)"

# Upload to CurseForge (if token configured)
if [ -n "$CURSEFORGE_TOKEN" ]; then
    echo "📤 Uploading to CurseForge..."
    
    curl -X POST "https://wow.curseforge.com/api/projects/1520857/upload-file" \
        -H "X-Api-Token: $CURSEFORGE_TOKEN" \
        -F "metadata={\"changelog\":\"See CHANGELOG.md\",\"changelogType\":\"markdown\",\"displayName\":\"Profession Helper v${VERSION}\",\"gameVersions\":[11302,11303],\"releaseType\":\"release\"}" \
        -F "file=@ProfessionHelper-v${VERSION}.zip"
    
    if [ $? -eq 0 ]; then
        echo "✅ Uploaded to CurseForge"
    else
        echo "⚠️ CurseForge upload failed (non-fatal)"
    fi
else
    echo "⏭️ Skipping CurseForge (token not configured)"
fi

# Upload to WoWInterface (if token configured)
if [ -n "$WOWI_API_TOKEN" ]; then
    echo "📤 Uploading to WoWInterface..."
    
    curl -X POST "https://api.wowinterface.com/addons/update" \
        -H "x-api-token: $WOWI_API_TOKEN" \
        -F "id=YOUR_ADDON_ID" \
        -F "version=$VERSION" \
        -F "updatefile=@ProfessionHelper-v${VERSION}.zip" \
        -F "changelog=$(cat CHANGELOG.md)"
    
    if [ $? -eq 0 ]; then
        echo "✅ Uploaded to WoWInterface"
    else
        echo "⚠️ WoWInterface upload failed (non-fatal)"
    fi
else
    echo "⏭️ Skipping WoWInterface (token not configured)"
fi

# Cleanup
rm -rf package/

echo "🎉 Release v${VERSION} published successfully!"
