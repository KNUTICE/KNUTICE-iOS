//
//  TopicSubscriptionFeature.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/9/25.
//

import ComposableArchitecture
import Foundation
import KNUTICECore

struct TopicSubscriptionListFeature: Reducer {
    // MARK: - State
    struct State: Equatable {
        var noticeSubscriptionStates: [NoticeCategory: Bool] = [:]
        var isMajorNoticeNotificationSubscribed: Bool = false
        var isLoading: Bool = false
        var isShowingAlert: Bool = false
        var isShowingFCMTokenErrorAlert: Bool = false
        var alertMessage: String = ""
    }
    
    // MARK: - Action
    @CasePathable
    enum Action {
        case onAppear
        case onDisappear
        
        case subscriptionsResponse(Result<[TopicSubscriptionKey], Error>)
        
        case toggleNotice(NoticeCategory, Bool)
        case toggleNoticeState(NoticeCategory, Bool)
        case toggleMajor(Bool)
        case toggleMajorState(Bool)
        
        case setLoading(Bool)
        case showAlert(String)
        case showFCMTokenErrorAlert(Bool)
        case setMajorNotificationSubscribed(Bool)
    }
    
    // MARK: - Dependency
    @Dependency(\.fetchTopicSubscriptionUseCase) var fetchTopicSubscriptionUseCase
    @Dependency(\.updateTopicSubscriptionUseCase) var updateTopicSubscriptionUseCase
    
    enum CancelID { case fetch, update }
    
    // MARK: - Reducer
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            // 서버에서 공지 구독 목록을 가져오는 비동기 네트워크 요청 시작
            return .run { send in
                await send(.setLoading(true))
                
                do {
                    let list = try await fetchTopicSubscriptionUseCase.execute(for: .notice)
                    await send(.subscriptionsResponse(.success(list)))
                } catch {
                    await send(.subscriptionsResponse(.failure(error)))
                }
                
                await send(.setLoading(false))
            }
            .cancellable(id: CancelID.fetch, cancelInFlight: true)
            
        case .onDisappear:
            // 화면이 사라질 때 진행 중이던 구독 조회 네트워크 요청 취소
            return .cancel(id: CancelID.fetch)
            
        case .subscriptionsResponse(.success(let subscriptions)):
            // 서버에서 받은 구독 결과를 UI 상태(State)에 반영
            for subscription in subscriptions {
                if case .notice(let topic) = subscription {
                    state.noticeSubscriptionStates[topic] = true
                }
            }
            
            state.isMajorNoticeNotificationSubscribed = UserDefaults.standard.bool(
                forKey: UserDefaultsKeys.isMajorNotificationSubscribed.rawValue
            )
            
            return .none
            
        case .subscriptionsResponse(.failure(let error)):
            // 네트워크 실패를 Alert 또는 FCM 오류 상태로 변환하여 UI에 전달
            if let afError = error.asAFError,
               case .requestAdaptationFailed(let underlying) = afError,
               underlying is KNUTICECore.TokenError {
                state.isShowingFCMTokenErrorAlert = true
            } else {
                state.alertMessage = "잠시 후 다시 시도해주세요."
                state.isShowingAlert = true
            }
            
            print("\(error.localizedDescription)")
            return .none
            
        case .toggleNotice(let topic, let isEnabled):
            // 공지 구독 상태 변경을 서버에 반영하는 비동기 업데이트 요청 수행
            return .run { send in
                await send(.setLoading(true))
                
                do {
                    try await updateTopicSubscriptionUseCase.execute(
                        of: .notice,
                        topic: topic,
                        isEnabled: isEnabled
                    )
                    await send(.toggleNoticeState(topic, isEnabled))
                } catch {
                    await send(.showAlert("알림 상태를 변경할 수 없어요."))
                }
                
                await send(.setLoading(false))
            }
            .cancellable(id: CancelID.update, cancelInFlight: true)
            
        case .toggleNoticeState(let topic, let isEnabled):
            // 서버 업데이트 성공 후 로컬 State를 실제 값으로 동기화
            state.noticeSubscriptionStates[topic] = isEnabled
            return .none
            
        case let .toggleMajor(isEnabled):
            // 학과 구독 상태를 서버에 저장하는 비동기 네트워크 요청 수행
            return .run { send in
                await send(.setLoading(true))
                
                if let majorStr = UserDefaults.shared?.string(forKey: UserDefaultsKeys.selectedMajor.rawValue),
                   let major = MajorCategory(rawValue: majorStr) {
                    try await updateTopicSubscriptionUseCase.execute(
                        of: .major,
                        topic: major,
                        isEnabled: isEnabled
                    )
                    await send(.toggleMajorState(isEnabled))
                    await send(.setMajorNotificationSubscribed(isEnabled))
                }
                
                await send(.setLoading(false))
            }
            .cancellable(id: CancelID.update, cancelInFlight: true)
            
        case let .toggleMajorState(isEnable):
            state.isMajorNoticeNotificationSubscribed = isEnable
            return .none
            
        case .setLoading(let value):
            // 로딩 인디케이터 표시 여부를 UI 상태로 변경
            state.isLoading = value
            return .none
            
        case .showAlert(let message):
            // 사용자에게 보여줄 에러 메시지를 Alert용 상태로 저장
            state.alertMessage = message
            state.isShowingAlert = true
            return .none
            
        case .showFCMTokenErrorAlert(let value):
            // FCM 토큰 오류 발생 여부를 Alert 상태로 제어
            state.isShowingFCMTokenErrorAlert = value
            return .none
            
        case let .setMajorNotificationSubscribed(isEnabled):
            UserDefaults.standard.set(isEnabled, forKey: UserDefaultsKeys.isMajorNotificationSubscribed.rawValue)
            return .none
        }
    }
}
