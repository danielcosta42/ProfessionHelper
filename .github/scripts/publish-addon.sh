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

CURSEFORGE_PROJECT_ID="1520857"

# Upload to CurseForge (if token configured)
if [ -n "$CURSEFORGE_TOKEN" ]; then
    echo "📤 Uploading to CurseForge (project: $CURSEFORGE_PROJECT_ID)..."

    # Fetch valid game version IDs from CurseForge API and filter for Classic/TBC (1.x and 2.x)
    echo "🔍 Fetching CurseForge game versions..."
    VERSIONS_JSON=$(curl -s "https://wow.curseforge.com/api/game/versions" \
        -H "X-Api-Token: $CURSEFORGE_TOKEN")

    GAME_VERSION_IDS=$(echo "$VERSIONS_JSON" | node -e "
let d='';
process.stdin.on('data',c=>d+=c).on('end',()=>{
  try {
    const data = JSON.parse(d);
    const ids = data
      .filter(v => v.name && (v.name.match(/^2\./) || v.name.match(/^1\./)))
      .map(v => v.id);
    console.log(ids.join(','));
  } catch(e) { console.log(''); }
});
")

    if [ -z "$GAME_VERSION_IDS" ]; then
        echo "⚠️ Could not resolve CurseForge game version IDs. Raw response:"
        echo "$VERSIONS_JSON" | head -c 500
        echo "⚠️ Skipping CurseForge upload"
    else
        echo "🔍 Using game version IDs: [$GAME_VERSION_IDS]"

        RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
            "https://wow.curseforge.com/api/projects/${CURSEFORGE_PROJECT_ID}/upload-file" \
            -H "X-Api-Token: $CURSEFORGE_TOKEN" \
            -F "metadata={\"changelog\":\"See CHANGELOG.md\",\"changelogType\":\"markdown\",\"displayName\":\"Profession Helper v${VERSION}\",\"gameVersions\":[${GAME_VERSION_IDS}],\"releaseType\":\"release\"}" \
            -F "file=@ProfessionHelper-v${VERSION}.zip")

        HTTP_CODE=$(echo "$RESPONSE" | tail -n1)

        if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "201" ]; then
            echo "✅ Uploaded to CurseForge"
        else
            echo "⚠️ CurseForge upload failed (HTTP $HTTP_CODE) — non-fatal"
            echo "$RESPONSE" | head -n-1
        fi
    fi
else
    echo "⏭️ Skipping CurseForge (CURSEFORGE_TOKEN secret not configured)"
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
