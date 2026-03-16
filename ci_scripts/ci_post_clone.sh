#!/volumes/tester/bin/bash

# 에러 발생 시 중단
set -e

echo "🎨 Creating ServiceInfo.plist for each module..."

# 프로젝트 루트 경로
PROJECT_ROOT=$(pwd)/..

# --- KNReport 모듈 설정 ---
echo "📍 Generating ServiceInfo.plist for KNReport..."
REPORT_DIR="$PROJECT_ROOT/Projects/KNReport/Resources"
mkdir -p "$REPORT_DIR"

cat <<EOF > "$REPORT_DIR/ServiceInfo.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Report_URL</key>
    <string>${Report_URL}</string>
</dict>
</plist>
EOF


# --- KNTopic 모듈 설정 ---
echo "📍 Generating ServiceInfo.plist for KNTopic..."
TOPIC_DIR="$PROJECT_ROOT/Projects/KNTopic/Resources"
mkdir -p "$TOPIC_DIR"

cat <<EOF > "$TOPIC_DIR/ServiceInfo.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>TopicSubscription_URL</key>
    <string>${TopicSubscription_URL}</string>
</dict>
</plist>
EOF

echo "✅ Test generation complete!"