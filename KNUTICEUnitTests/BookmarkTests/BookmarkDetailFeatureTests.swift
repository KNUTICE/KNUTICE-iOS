//
//  BookmarkDetailFeatureTests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/23/25.
//

import ComposableArchitecture
import KNUTICECore
import XCTest
@testable import KNUTICE

@MainActor
final class BookmarkDetailFeatureTests: XCTestCase {
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
    
    // 웹뷰 토글 테스트
    func testToggleWebView() async {
        let store = TestStore(
            initialState: BookmarkDetailFeature.State(bookmark: mockBookmark)
        ) {
            BookmarkDetailFeature()
        }
        
        // true로 변경
        await store.send(.toggleWebView(true)) {
            $0.isShowingWebView = true
        }
        
        // false로 변경
        await store.send(.toggleWebView(false)) {
            $0.isShowingWebView = false
        }
    }
    
    // 수정 버튼 탭 (Delegate 전달 확인)
    func testEditButtonTapped() async {
        let store = TestStore(
            initialState: BookmarkDetailFeature.State(bookmark: mockBookmark)
        ) {
            BookmarkDetailFeature()
        }
        
        await store.send(.editButtonTapped)
        await store.receive(\.delegate.switchToEditMode)
    }
    
    // 삭제 버튼 탭 (Delegate 전달 확인)
    func testDeleteButtonTapped() async {
        let store = TestStore(
            initialState: BookmarkDetailFeature.State(bookmark: mockBookmark)
        ) {
            BookmarkDetailFeature()
        }
        
        await store.send(.deleteButtonTapped)
        await store.receive(\.delegate.deleteBookmark)
    }
    
    // 삭제 성공 테스트 (Alert 표시 -> 확인 -> Dismiss)
    func testDeleteBookmarkSuccess() async {
        let store = TestStore(
            initialState: BookmarkDetailFeature.State(bookmark: mockBookmark)
        ) {
            BookmarkDetailFeature()
        }
        
        // 부모로부터 성공 응답을 받았다고 가정
        await store.send(.deleteBookmarkResponse(.success(()))) {
            $0.alert = AlertState {
                TextState("알림")
            } actions: {
                ButtonState(action: .confirmDeletion) {
                    TextState("확인")
                }
            } message: {
                TextState("북마크 삭제를 완료했어요.")
            }
        }
        
        // Alert의 '확인' 버튼 탭
        await store.send(.alert(.presented(.confirmDeletion))) {
            $0.alert = nil // Alert이 닫힘
            $0.shouldDismiss = true // 화면 닫힘 플래그가 켜짐
        }
    }
    
    // 삭제 실패 테스트 (에러 Alert 표시)
    func testDeleteBookmarkFailure() async {
        let store = TestStore(
            initialState: BookmarkDetailFeature.State(bookmark: mockBookmark)
        ) {
            BookmarkDetailFeature()
        }
        
        struct MockError: Error, Equatable {}
        
        // 부모로부터 실패 응답을 받았다고 가정
        await store.send(.deleteBookmarkResponse(.failure(MockError()))) {
            $0.alert = AlertState {
                TextState("알림")
            } message: {
                TextState("현재 북마크를 삭제할 수 없어요.\n잠시 후 다시 시도해 주세요.")
            }
        }
        
        // Alert 닫기
        await store.send(.alert(.dismiss)) {
            $0.alert = nil
        }
    }

}
