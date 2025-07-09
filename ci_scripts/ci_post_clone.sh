#!/bin/sh

#  ci_post_clone.sh
#  KNUTICE
#
#  Created by 이정훈 on 8/8/24.
#

# ServiceInfo.plist 변수 변경
echo "환경변수 참조 ServiceInfo.plist 생성"

cat <<EOF > "/Volumes/workspace/repository/KNUTICE/Application/ServiceInfo.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Notice_URL</key>
    <string>${Notice_URL}</string>
    <key>Report_URL</key>
    <string>${Report_URL}</string>
    <key>Token_URL</key>
    <string>${Token_URL}</string>
    <key>Main_Notice_URL</key>
    <string>${Main_Notice_URL}</string>
    <key>OpenSourceLicenseURL</key>
    <string>${OpenSourceLicenseURL}</string>
    <key>Search_URL</key>
    <string>${Search_URL}</string>
    <key>Notification_Permission_URL</key>
    <string>${Notification_Permission_URL}</string>
    <key>Main_Popup_URL</key>
    <string>${Main_Popup_URL}</string>
    <key>Notice_Sync_URL</key>
    <string>${Notice_Sync_URL}</string>
    <key>DefaultThumbnail_URL</key>
    <string>${DefaultThumbnail_URL}</string>
    <key>Beta_Version</key>
    <string>${Beta_Version}</string>
    <key>TipURL</key>
    <string>${TipURL}</string>
</dict>
</plist>
EOF

echo "ServiceInfo.plist 생성 완료"

# Boolean 값 변환
convert_bool() {
    if [ "$1" = "true" ]; then
        echo "<true/>"
    else
        echo "<false/>"
    fi
}

# GoogleService-Info.plist 파일 생성
echo "환경변수 참조 GoogleService-Info.plist file 생성시작"
cat <<EOF > "/Volumes/workspace/repository/KNUTICE/GoogleService-Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>API_KEY</key>
    <string>${API_KEY}</string>
    <key>GCM_SENDER_ID</key>
    <string>${GCM_SENDER_ID}</string>
    <key>PLIST_VERSION</key>
    <string>${PLIST_VERSION}</string>
    <key>BUNDLE_ID</key>
    <string>${BUNDLE_ID}</string>
    <key>PROJECT_ID</key>
    <string>${PROJECT_ID}</string>
    <key>STORAGE_BUCKET</key>
    <string>${STORAGE_BUCKET}</string>
    <key>IS_ADS_ENABLED</key>
    `convert_bool ${IS_ADS_ENABLED}`
    <key>IS_ANALYTICS_ENABLED</key>
    `convert_bool ${IS_ANALYTICS_ENABLED}`
    <key>IS_APPINVITE_ENABLED</key>
    `convert_bool ${IS_APPINVITE_ENABLED}`
    <key>IS_GCM_ENABLED</key>
    `convert_bool ${IS_GCM_ENABLED}`
    <key>IS_SIGNIN_ENABLED</key>
    `convert_bool ${IS_SIGNIN_ENABLED}`
    <key>GOOGLE_APP_ID</key>
    <string>${GOOGLE_APP_ID}</string>
</dict>
</plist>
EOF
echo "환경변수 참조 GoogleService-Info.plist file 생성완료"

# GoogleService-Info-Dev.plist 파일 생성
echo "환경변수 참조 GoogleService-Info-Dev.plist file 생성시작"
cat <<EOF > "/Volumes/workspace/repository/KNUTICE/GoogleService-Info-Dev.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>API_KEY</key>
    <string>${API_KEY}</string>
    <key>GCM_SENDER_ID</key>
    <string>${GCM_SENDER_ID}</string>
    <key>PLIST_VERSION</key>
    <string>${PLIST_VERSION}</string>
    <key>BUNDLE_ID</key>
    <string>${BUNDLE_ID}</string>
    <key>PROJECT_ID</key>
    <string>${PROJECT_ID}</string>
    <key>STORAGE_BUCKET</key>
    <string>${STORAGE_BUCKET}</string>
    <key>IS_ADS_ENABLED</key>
    `convert_bool ${IS_ADS_ENABLED}`
    <key>IS_ANALYTICS_ENABLED</key>
    `convert_bool ${IS_ANALYTICS_ENABLED}`
    <key>IS_APPINVITE_ENABLED</key>
    `convert_bool ${IS_APPINVITE_ENABLED}`
    <key>IS_GCM_ENABLED</key>
    `convert_bool ${IS_GCM_ENABLED}`
    <key>IS_SIGNIN_ENABLED</key>
    `convert_bool ${IS_SIGNIN_ENABLED}`
    <key>GOOGLE_APP_ID</key>
    <string>${GOOGLE_APP_ID}</string>
</dict>
</plist>
EOF
echo "환경변수 참조 GoogleService-Info-Dev.plist file 생성완료"
