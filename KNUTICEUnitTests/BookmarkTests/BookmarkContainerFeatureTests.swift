//
//  BookmarkContainerFeatureTests.swift
//  KNUTICEUnitTests
//
//  Created by 이정훈 on 12/23/25.
//

import ComposableArchitecture
import KNUTICECore
import XCTest
@testable import KNUTICE

@MainActor
final class BookmarkContainerFeatureTests: XCTestCase {
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
    
    func testTransition_DetailToEdit() async {
        let store = TestStore(
            initialState: BookmarkContainerFeature.State.detail(
                BookmarkDetailFeature.State(bookmark: mockBookmark)
            )
        ) {
            BookmarkContainerFeature()
        }
        
        // Edit 모드 진입 요청
        await store.send(\.detail.delegate.switchToEditMode) {
            // State가 .edit으로 변경되어야 함
            // 이때 original과 bookmark 모두 mockBookmark로 초기화되는지 확인
            $0 = .edit(
                BookmarkFormFeature.State(
                    bookmark: self.mockBookmark,
                    original: self.mockBookmark,
                    formType: .update
                )
            )
        }
    }
    
    func testTransition_EditToDetail() async {
        // 수정된 북마크 데이터 가정
        var updatedBookmark = mockBookmark
        updatedBookmark.memo = "Updated Contents"
        
        let store = TestStore(
            initialState: BookmarkContainerFeature.State.edit(
                BookmarkFormFeature.State(
                    bookmark: updatedBookmark,
                    original: mockBookmark,
                    formType: .update
                )
            )
        ) {
            BookmarkContainerFeature()
        }
        
        // Detail 모드로 복귀 요청 (수정된 데이터 전달)
        await store.send(\.edit.delegate.switchToDetailMode, updatedBookmark) {
            // State가 .detail로 변경되고, 전달받은 updatedBookmark를 표시해야 함
            $0 = .detail(
                BookmarkDetailFeature.State(bookmark: updatedBookmark)
            )
        }
    }
    
    func testDeleteBookmarkFlow_Success() async {
        let store = TestStore(
            initialState: BookmarkContainerFeature.State.detail(
                BookmarkDetailFeature.State(bookmark: mockBookmark)
            )
        ) {
            BookmarkContainerFeature()
        } withDependencies: {
            $0.deleteBookmarkUseCase = DeleteBookmarkSuccessUseCase()
        }
        
        // 삭제 요청을 보냄
        await store.send(.detail(.delegate(.deleteBookmark)))
        
        // UseCase 실행 후, 성공 응답 Action 전달
        await store.receive(\.detail.deleteBookmarkResponse) { state in
            guard case .detail(var detailState) = state else {
                XCTFail("State should be in .detail case")
                return
            }
            
            detailState.alert = AlertState {
                TextState("알림")
            } actions: {
                ButtonState(action: .confirmDeletion) {
                    TextState("확인")
                }
            } message: {
                TextState("북마크 삭제를 완료했어요.")
            }
            
            state = .detail(detailState)
        }
        
    }
    
    func testDeleteBookmarkFlow_Failure() async {
        struct DeleteError: Error, Equatable {}
        
        let store = TestStore(
            initialState: BookmarkContainerFeature.State.detail(
                BookmarkDetailFeature.State(bookmark: mockBookmark)
            )
        ) {
            BookmarkContainerFeature()
        } withDependencies: {
            $0.deleteBookmarkUseCase = DeleteBookmarkFailureUseCase()
        }
        
        await store.send(\.detail.delegate.deleteBookmark)
        
        // 실패 결과 Action 전달
        await store.receive(\.detail.deleteBookmarkResponse) { state in
            guard case .detail(var detailState) = state else {
                XCTFail("State should be in .detail case")
                return
            }
            
            detailState.alert = AlertState {
                TextState("알림")
            } message: {
                TextState("현재 북마크를 삭제할 수 없어요.\n잠시 후 다시 시도해 주세요.")
            }
            
            state = .detail(detailState)
        }
    }
    
    func testSaveBookmarkFlow_Success() async {
        var updatedBookmark = mockBookmark
        updatedBookmark.memo = "Updated"
        
        let store = TestStore(
            initialState: BookmarkContainerFeature.State.edit(
                BookmarkFormFeature.State(
                    bookmark: updatedBookmark,
                    original: mockBookmark,
                    formType: .update
                )
            )
        ) {
            BookmarkContainerFeature()
        } withDependencies: {
            $0.updateBookmarkUseCase = UpdateBookmarkSuccessUseCase()
        }
        
        // 저장 요청을 보냄
        await store.send(\.edit.delegate.save, updatedBookmark)
        
        // 성공 응답 Action 전달
        await store.receive(\.edit.saveBookmarkResponse) { state in
               guard case .edit(var editState) = state else {
                   XCTFail("State should be in .detail case")
                   return
               }
            
            editState.alert = AlertState {
                TextState("알림")
            } actions: {
                ButtonState(action: .saveCompleted) {
                    TextState("확인")
                }
            } message: {
                TextState("북마크 저장이 완료되었어요.")
            }
            
            state = .edit(editState)
        }
    }

}
