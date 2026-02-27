//
//  TopicSubscriptionFeature.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/9/25.
//

import ComposableArchitecture
import Foundation
import KNNetwork
import KNUtility

@Reducer
public struct TopicSubscriptionListFeature {
    // MARK: - State
    
    @ObservableState
    public struct State: Equatable {
        var noticeSubscriptionStates: [NoticeCategory: Bool] = [:]
        var isMajorNoticeNotificationSubscribed: Bool = false
        var isStudentCafeteriaNotificationSubscribed: Bool = false
        var isStaffCafeteriaNotificationSubscribed: Bool = false
        var isLoading: Bool = false
        @Presents var alert: AlertState<Action.Alert>?
        @Presents var fcmTokenErrorAlert: AlertState<Action.Alert>?
        
        public init() {}
    }
    
    // MARK: - Action
    public enum Action {        
        case onAppear
        case onDisappear
        case errorResponse(any Error)
        case noticeSubscriptionsResponse([TopicSubscriptionKey])
        case cafeteriaSubscriptionsResponse([TopicSubscriptionKey])
        case toggleNotice(NoticeCategory, Bool)
        case toggleNoticeState(NoticeCategory, Bool)
        case toggleMajor(Bool)
        case toggleMajorState(Bool)
        case toggleCafeteria(CafeteriaCategory, Bool)
        case toggleCafeteriaState(CafeteriaCategory, Bool)
        case setLoading(Bool)
        case setMajorNotificationSubscribed(Bool)
        case alert(PresentationAction<Alert>)
        case fcmTokenErrorAlert(PresentationAction<Alert>)
        
        public enum Alert: Equatable {
            case dismiss
            case confirmFCMError
        }
    }
    
    // MARK: - Dependency
    @Dependency(\.fetchTopicSubscriptionUseCase) var fetchTopicSubscriptionUseCase
    @Dependency(\.updateTopicSubscriptionUseCase) var updateTopicSubscriptionUseCase
    @Dependency(\.dismiss) var dismiss
    
    enum CancelID {
        case fetch
        case updateNotice
        case updateMajor
        case updateCafeteria
    }
    
    public init() {}
    
    // MARK: - Reducer
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // 서버에서 공지 구독 목록을 가져오는 비동기 네트워크 요청 시작
                return .merge(
                    .run { send in
                        await send(.setLoading(true))
                        
                        do {
                            let list = try await fetchTopicSubscriptionUseCase.execute(for: .notice)
                            await send(.noticeSubscriptionsResponse(list))
                        } catch {
                            await send(.errorResponse(error))
                        }
                        
                        await send(.setLoading(false))
                    },
                    .run { send in
                        do {
                            let subscriptions = try await fetchTopicSubscriptionUseCase.execute(for: .meal)
                            await send(.cafeteriaSubscriptionsResponse(subscriptions))
                        } catch {
                            await send(.errorResponse(error))
                        }
                    },
                )
                .cancellable(id: CancelID.fetch, cancelInFlight: true)
                
            case .onDisappear:
                // 화면이 사라질 때 진행 중이던 구독 조회 네트워크 요청 취소
                return .merge(
                    .cancel(id: CancelID.fetch),
                    .cancel(id: CancelID.updateNotice),
                    .cancel(id: CancelID.updateMajor),
                    .cancel(id: CancelID.updateCafeteria)
                )
                
            case .noticeSubscriptionsResponse(let subscriptions):
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
                
            case .errorResponse(let error):
                if let afError = error.asAFError,
                   case .requestAdaptationFailed(let underlying) = afError,
                   underlying is TokenError {
                    state.fcmTokenErrorAlert = AlertState {
                        TextState("알림")
                    } actions: {
                        ButtonState(action: .confirmFCMError) {    // 버튼 클릭 시 .confirmFCMError 액션 발생
                            TextState("확인")
                        }
                    } message: {
                        TextState("현재 서비스를 이용할 수 없습니다.\n잠시 후에 다시 시도해 주세요.")
                    }
                } else {
                    state.alert = AlertState {
                        TextState("알림 상태를 변경할 수 없어요.")
                    } actions: {
                        ButtonState(action: .dismiss) {    // 버튼 클릭 시, .dismiss 액션 발생
                            TextState("확인")
                        }
                    } message: {
                        TextState("잠시 후 다시 시도해주세요.")
                    }
                }
                return .none
                
            case .cafeteriaSubscriptionsResponse(let subscriptions):
                for subscription in subscriptions {
                    switch subscription {
                    case .studentCafeteria:
                        state.isStudentCafeteriaNotificationSubscribed = true
                    case .staffCafeteria:
                        state.isStaffCafeteriaNotificationSubscribed = true
                    default:
                        continue
                    }
                }
                return .none
                
            case .fcmTokenErrorAlert(.presented(.confirmFCMError)):
                return .run { _ in
                    await dismiss()
                }
                
            case .alert, .fcmTokenErrorAlert:
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
                        await send(.errorResponse(error))
                    }
                    
                    await send(.setLoading(false))
                }
                .cancellable(id: CancelID.updateNotice, cancelInFlight: true)
                
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
                .cancellable(id: CancelID.updateMajor, cancelInFlight: true)
                
            case let .toggleMajorState(isEnable):
                state.isMajorNoticeNotificationSubscribed = isEnable
                return .none
                
            case .toggleCafeteria(let category, let isEnabled):
                return .run { send in
                    await send(.setLoading(true))
                    
                    do {
                        try await updateTopicSubscriptionUseCase.execute(of: .meal, topic: category, isEnabled: isEnabled)
                        await send(.toggleCafeteriaState(category, isEnabled))
                    } catch {
                        await send(.errorResponse(error))
                    }
                    
                    await send(.setLoading(false))
                }
                .cancellable(id: CancelID.updateCafeteria, cancelInFlight: true)
                
            case .toggleCafeteriaState(let category, let isEnabled):
                switch category {
                case .studentCafeteria:
                    state.isStudentCafeteriaNotificationSubscribed = isEnabled
                case .staffCafeteria:
                    state.isStaffCafeteriaNotificationSubscribed = isEnabled
                }
                return .none
                
            case .setLoading(let value):
                // 로딩 인디케이터 표시 여부를 UI 상태로 변경
                state.isLoading = value
                return .none
                
            case let .setMajorNotificationSubscribed(isEnabled):
                UserDefaults.standard.set(isEnabled, forKey: UserDefaultsKeys.isMajorNotificationSubscribed.rawValue)
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.$fcmTokenErrorAlert, action: \.fcmTokenErrorAlert)
    }
}
