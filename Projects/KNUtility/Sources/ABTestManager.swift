//
//  ABTestManager.swift
//  KNUtility
//
//  Created by 이정훈 on 2/2/26.
//

import FirebaseRemoteConfig

public actor ABTestManager {
    public static let shared: ABTestManager = .init()
    private var remoteConfig = RemoteConfig.remoteConfig()
    private var isRemoteConfigFetched: Bool = false
    
    private init() {
        // 기본값 설정 (서버 연결 실패 시 사용)
        let defaultValues: [String: NSObject] = [
            "notice_detail_layout_type": "type_A" as NSObject
        ]
        remoteConfig.setDefaults(defaultValues)
        
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0 // 0초로 설정하여 즉시 업데이트 허용
        #endif
        remoteConfig.configSettings = settings
    }
    
    public func getString(key: String) async throws -> String {        
        guard !isRemoteConfigFetched else { return remoteConfig[key].stringValue ?? "" }
        
        try await remoteConfig.fetch()
        try await remoteConfig.activate()
        
        isRemoteConfigFetched = true
        
        return remoteConfig[key].stringValue ?? ""
    }
}
