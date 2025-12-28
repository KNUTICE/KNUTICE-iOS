//
//  BookmarkFormFeatureTests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/23/25.
//

import ComposableArchitecture
import KNUTICECore
import XCTest
@testable import KNUTICE

@MainActor
final class BookmarkFormFeatureTests: XCTestCase {

    let mockBookmark = Bookmark(
        notice: Notice(
            id: 1082442,
            title: "교과/비교과 캡스톤디자인 운영안내 및 경진대회 설명회",
            contentUrl: "https://www.ut.ac.kr/cop/bbs/BBSMSTR_000000000059/selectBoardArticle.do;jsessionid=oaml4mu0PaaatzeYKCb9RxesTJJ1EbpNKVhkXKWbxMNlXok2lKtpwL1wUfrelZZp.knut_servlet_homepage?nttId=1082442",
            department: "지역혁신전략실",
            uploadDate: "2025-09-08",
            imageUrl: "http://www.ut.ac.kr/namo/binary/images/000100/제목을_입력하세요_(2).png",
            noticeCategory: .generalNotice,
            majorCategory: nil
        ),
        memo: "",
        alarmDate: nil
    )
    
    func testCreateMode_SaveSuccess() async {
        let store = TestStore(
            initialState: BookmarkFormFeature.State(
                bookmark: mockBookmark,
                original: mockBookmark,
                formType: .create
            )
        ) {
            BookmarkFormFeature()
        } withDependencies: {
            $0.saveBookmarkUseCase = SaveBookmarkSuccessUseCase()
        }
        
        // 저장 버튼 탭
        await store.send(.saveButtonTapped)
        
        // 성공 응답 수신
        await store.receive(\.saveBookmarkResponse) {
            $0.alert = AlertState {
                TextState("알림")
            } actions: {
                ButtonState(action: .saveCompleted) {
                    TextState("확인")
                }
            } message: {
                TextState("북마크 저장이 완료되었어요.")
            }
        }
        
        // Alert 확인 버튼 탭 -> 화면 닫힘
        await store.send(.alert(.presented(.saveCompleted))) {
            $0.alert = nil
            $0.shouldDismiss = true
        }
    }
    
    func testCreateMode_SaveDuplicateFailure() async {
        let store = TestStore(
            initialState: BookmarkFormFeature.State(
                bookmark: mockBookmark,
                original: mockBookmark,
                formType: .create
            )
        ) {
            BookmarkFormFeature()
        } withDependencies: {
            $0.saveBookmarkUseCase = FailSavingExistingBookmarkUseCase()
        }
        
        // 저장 버튼 탭
        await store.send(.saveButtonTapped)
        
        // 실패 응답 및 Alert 확인
        await store.receive(\.saveBookmarkResponse) {
            $0.alert = AlertState {
                TextState("알림")
            } message: {
                TextState("이미 존재하는 북마크에요.")
            }
        }
    }
    
    func testUpdateMode_SaveDelegate() async {
        let store = TestStore(
            initialState: BookmarkFormFeature.State(
                bookmark: mockBookmark,
                original: mockBookmark,
                formType: .update
            )
        ) {
            BookmarkFormFeature()
        }
        
        // Update 모드에서는 UseCase를 실행하지 않고 Delegate 액션을 보냄
        await store.send(.saveButtonTapped)
        
        // 저장하려는 북마크 데이터와 함께 Delegate 액션 수신 확인
        await store.receive(\.delegate.save)
    }
    
    func testCancel_InCreateMode() async {
        let store = TestStore(
            initialState: BookmarkFormFeature.State(
                bookmark: mockBookmark,
                original: mockBookmark,
                formType: .create
            )
        ) {
            BookmarkFormFeature()
        }
        
        // Create 모드 취소 -> 단순히 화면 닫기
        await store.send(.cancelButtonTapped) {
            $0.shouldDismiss = true
        }
    }
    
    func testCancel_InUpdateMode() async {
        let store = TestStore(
            initialState: BookmarkFormFeature.State(
                bookmark: mockBookmark,
                original: mockBookmark,
                formType: .update
            )
        ) {
            BookmarkFormFeature()
        }
        
        // Update 모드 취소 -> 원본 데이터 들고 상세 화면으로 전환
        await store.send(.cancelButtonTapped)
        
        // switchToDetailMode 액션 수신
        await store.receive(\.delegate.switchToDetailMode)
    }
    
}
