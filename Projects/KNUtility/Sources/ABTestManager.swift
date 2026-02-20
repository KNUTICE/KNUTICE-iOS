//
//  ABTestManager.swift
//  KNUtility
//
//  Created by 이정훈 on 2/2/26.
//

import FirebaseRemoteConfig

public actor ABTestManager {
    /// Represents the current state of the Remote Config fetch process.
    private enum FetchStatus {
        /// No fetch has been attempted yet.
        case idle
        /// A fetch task is currently in progress.
        case fetching(Task<RemoteConfigFetchAndActivateStatus, any Error>)
        /// Remote Config has been successfully fetched and activated.
        case fetched
    }
    
    /// The shared singleton instance of the `ABTestManager`.
    public static let shared: ABTestManager = .init()
    
    /// The internal Firebase Remote Config instance.
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    /// The current lifecycle status of the configuration fetch.
    private var status: FetchStatus = .idle
    
    private init() {
        // 기본 값 세팅
        let defaultValues: [String: NSObject] = [
            "notice_detail_layout_type": "type_A" as NSObject
        ]
        remoteConfig.setDefaults(defaultValues)
        
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0    // 0초로 설정하여 즉시 업데이트 허용
        #endif
        remoteConfig.configSettings = settings
    }
    
    /// Fetches and activates the latest configuration from the Firebase server.
    ///
    /// If a fetch is already in progress, it waits for the existing task to complete.
    /// If the configuration has already been fetched, it returns immediately.
    ///
    /// - Note: In case of failure, the status is reset to `.idle` to allow subsequent retry attempts.
    public func fetchConfiguration() async {
        // 이미 패치 중이라면 해당 태스크를 대기
        if case let .fetching(task) = status {
            _ = try? await task.value
            return
        }
        
        // 완료되었다면 즉시 반환
        if case .fetched = status { return }
        
        let fetchTask = Task {
            try await remoteConfig.fetchAndActivate()
        }
        
        status = .fetching(fetchTask)
        
        do {
            _ = try await fetchTask.value
            status = .fetched
        } catch {
            status = .idle // 실패 시 다음 호출 때 재시도 가능하도록 초기화
            print("RemoteConfig Fetch Failed: \(error)")
        }
    }
    
    /// Retrieves the configuration string value for a given A/B test key.
    ///
    /// This method ensures that the Remote Config data is ready before returning the value.
    /// If the manager is in an `idle` or `fetching` state, it will await the completion
    /// of the fetch process.
    ///
    /// - Parameter key: A specific key defined in `ABTestKeys` to look up in Remote Config.
    /// - Returns: The string value associated with the key. Returns the default value if the fetch fails or the key is missing.
    ///
    /// - Note: This is an `async` method to handle potential network latency during the initial fetch.
    public func value(for key: ABTestKeys) async -> String {
        if case .idle = status, case .fetching = status {
            await fetchConfiguration()
        }
        
        // 이미 fetch된 값을 반환하거나, 실패 시 기본값을 반환합니다.
        return remoteConfig[key.rawValue].stringValue ?? ""
    }
}
