//
//  ReportFeatureTests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/15/25.
//

import ComposableArchitecture
import XCTest
@testable import KNUTICE

@MainActor
final class ReportFeatureTests: XCTestCase {

    func test_submitReport_success() async {
        let store = TestStore(
            initialState: ReportFeature.State()
        ) {
            ReportFeature()
        } withDependencies: {
            $0.submitReportUseCase = MockSubmitReportUseCaseSuccess()
        }
        
        await store.send(.binding(.set(\.content, "테스트 내용"))) {
            $0.content = "테스트 내용"
        }
        
        await store.send(.submitButtonTapped(device: "iPad13,16")) {
            $0.isLoading = true
        }
        
        await store.receive(\.submitResponse) {
            $0.isLoading = false
            $0.alert = AlertState {
                TextState("알림")
            } actions: {
                ButtonState(action: .reportSubmitted) {
                    TextState("확인")
                }
            } message: {
                TextState("제출을 완료했어요.")
            }
        }
    }
    
    func test_submitReport_failure() async {
        let store = TestStore(
            initialState: ReportFeature.State()
        ) {
            ReportFeature()
        } withDependencies: {
            $0.submitReportUseCase = MockSubmitReportUseCaseFailure()
        }
        
        await store.send(.binding(.set(\.content, "테스트 내용"))) {
            $0.content = "테스트 내용"
        }
        
        await store.send(.submitButtonTapped(device: "iPad13,16")) {
            $0.isLoading = true
        }
        
        await store.receive(\.submitResponse) {
            $0.isLoading = false
            $0.alert = AlertState {
                TextState("알림")
            } message: {
                TextState("작업을 완료할 수 없습니다.(KNUTICEUnitTests.MockSubmitReportError 오류 0.)")
            }
        }
    }


}
