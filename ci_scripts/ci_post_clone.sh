#!/volumes/tester/bin/bash

# 에러 발생 시 중단
set -e

# 환경 설정 (mise)
curl https://mise.run | sh
export PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash --shims)"

echo "❗️mise version: $(mise --version)"
mise install 

# 프로젝트 루트 경로 설정
# ci_scripts에서 실행되므로 한 단계 위가 루트
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ---------------------------------------------------------
# 리소스 파일 먼저 생성 (Tuist 실행 전!)
# ---------------------------------------------------------
echo "🎨 Creating ServiceInfo.plist for each module..."

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

# --- KNTip 모듈 설정 ---
echo "📍 Generating ServiceInfo.plist for KNTopic..."
TOPIC_DIR="$PROJECT_ROOT/Projects/KNTip/Resources"
mkdir -p "$TOPIC_DIR"
cat <<EOF > "$TOPIC_DIR/ServiceInfo.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>TipURL</key>
    <string>${TipURL}</string>
</dict>
</plist>
EOF

echo "✅ File generation complete!"

# ---------------------------------------------------------
# Tuist 작업 수행
# ---------------------------------------------------------
cd "$PROJECT_ROOT"

echo "❗️tuist install"
tuist install

echo "❗️tuist generate"
tuist generate --no-open

echo "🚀 All tasks completed successfully!"