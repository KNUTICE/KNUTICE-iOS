#!/usr/bin/env bash

# 에러 발생 시 중단
set -e

# 환경 설정 (mise)
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash --shims)"

echo "❗️mise version: $(mise --version)"
mise install 

#!/bin/bash

set -e

echo "Creating ServiceInfo.plist files..."

mkdir -p "Projects/Features/CorePresentation/Resources"
cat > "Projects/Features/CorePresentation/Resources/ServiceInfo.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>DefaultThumbnail_URL</key>
    <string>${DefaultThumbnail_URL}</string>
</dict>
</plist>
EOF

mkdir -p "Projects/Features/KNMeal/Resources"
cat > "Projects/Features/KNMeal/Resources/ServiceInfo.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Bridging_Method</key>
    <string>${Bridging_Method}</string>
    <key>Base_URL</key>
    <string>${Base_URL}</string>
</dict>
</plist>
EOF

mkdir -p "Projects/Features/KNReadingRoom/Resources"
cat > "Projects/Features/KNReadingRoom/Resources/ServiceInfo.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Navigation_Method</key>
    <string>${Navigation_Method}</string>
    <key>FCMToken_Method</key>
    <string>${FCMToken_Method}</string>
    <key>Reading_Room_Status_URL</key>
    <string>${Reading_Room_Status_URL}</string>
</dict>
</plist>
EOF

mkdir -p "Projects/Features/KNSetting/Resources"
cat > "Projects/Features/KNSetting/Resources/ServiceInfo.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>OpenSourceLicenseURL</key>
    <string>${OpenSourceLicenseURL}</string>
</dict>
</plist>
EOF

mkdir -p "Projects/KNData/Resources"
cat > "Projects/KNData/Resources/ServiceInfo.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Token_URL</key>
    <string>${Token_URL}</string>
    <key>Notice_Summary_URL</key>
    <string>${Notice_Summary_URL}</string>
    <key>ReadingRoom_URL</key>
    <string>${ReadingRoom_URL}</string>
    <key>TopicSubscription_URL</key>
    <string>${TopicSubscription_URL}</string>
    <key>TipURL</key>
    <string>${TipURL}</string>
    <key>Report_URL</key>
    <string>${Report_URL}</string>
    <key>Notice_URL</key>
    <string>${Notice_URL}</string>
</dict>
</plist>
EOF

mkdir -p "Projects/KNUtility/Resources"
cat > "Projects/KNUtility/Resources/ServiceInfo.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Team_Id</key>
    <string>${Team_Id}</string>
    <key>Beta_Version</key>
    <string>${Beta_Version}</string>
</dict>
</plist>
EOF

echo "ServiceInfo.plist files created."

# ---------------------------------------------------------
# Tuist 작업 수행
# ---------------------------------------------------------
cd "$PROJECT_ROOT"

echo "❗️tuist install"
tuist install

echo "❗️tuist generate"
tuist generate --no-open

echo "🚀 All tasks completed successfully!"