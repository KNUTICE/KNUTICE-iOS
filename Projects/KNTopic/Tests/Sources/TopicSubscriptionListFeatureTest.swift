//
//  TopicSubscriptionListFeatureTest.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/10/25.
//

import KNUtility
import XCTest
import ComposableArchitecture
@testable import KNTopic

@MainActor
final class TopicSubscriptionListFeatureTests: XCTestCase {

    private func makeTestStore() -> TestStore<TopicSubscriptionListFeature.State, TopicSubscriptionListFeature.Action> {
        TestStore(
            initialState: TopicSubscriptionListFeature.State()
        ) {
            TopicSubscriptionListFeature()
        } withDependencies: {
            $0.fetchTopicSubscriptionUseCase = MockFetchTopicSubscriptionUseCase()
            $0.updateTopicSubscriptionUseCase = MockUpdateTopicSubscriptionUseCase()
        }
    }

    func test_onAppear_success() async {
        let store = makeTestStore()
        
        // 사용자가 화면에 진입 테스트
        await store.send(.onAppear)
        
        // 구독 상태를 가져오는 동안 로딩 상태 변경
        await store.receive(\.setLoading) {
            $0.isLoading = true
        }
        
        await store.receive(\.cafeteriaSubscriptionsResponse) {
            $0.isStudentCafeteriaNotificationSubscribed = true
            $0.isStaffCafeteriaNotificationSubscribed = true
        }
        
        // onAppear 이후 subscriptionsResponse 액션이 발생하면 데이터 상태 검증
        await store.receive(\.noticeSubscriptionsResponse) {
            $0.noticeSubscriptionStates[.academicNotice] = true
            $0.noticeSubscriptionStates[.eventNotice] = true
            $0.isMajorNoticeNotificationSubscribed = true
        }
        
        // 요청이 끝난 후, 로딩 상태 변경
        await store.receive(\.setLoading) {
            $0.isLoading = false
        }
    }
    
    func test_noticeToggle_success() async {
        let store = makeTestStore()
        
        // 사용자가 토글 변경 테스트
        await store.send(.toggleNotice(.generalNotice, true))
        
        await store.receive(\.setLoading) {
            $0.isLoading = true
        }
        
        await store.receive(\.toggleNoticeState) {
            $0.noticeSubscriptionStates[.generalNotice] = true
        }
        
        // 토글 변경 후
        await store.receive(\.setLoading) {
            $0.isLoading = false
        }
    }
    
    func test_majorToggle_success() async {
        let store = makeTestStore()
        UserDefaults.shared?.set(
            "MECHANICAL_ENGINEERING",
            forKey: UserDefaultsKeys.selectedMajor.rawValue
        )
        
        await store.send(.toggleMajor(true))
        
        await store.receive(\.setLoading) {
            $0.isLoading = true
        }
        
        await store.receive(\.toggleMajorState) {
            $0.isMajorNoticeNotificationSubscribed = true
        }
        
        await store.receive(\.setMajorNotificationSubscribed)
        
        await store.receive(\.setLoading) {
            $0.isLoading = false
        }
    }
    
}

