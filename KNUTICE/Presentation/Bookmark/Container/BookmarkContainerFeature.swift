//
//  BookmarkContainerFeature.swift
//  KNUTICE
//
//  Created by 이정훈 on 12/16/25.
//

import ComposableArchitecture
import KNUTICECore

@Reducer
struct BookmarkContainerFeature {
        
    @ObservableState
    enum State: Equatable {
        case detail(BookmarkDetailFeature.State)
        case edit(BookmarkFormFeature.State)
    }

    enum Action {
        case detail(BookmarkDetailFeature.Action)
        case edit(BookmarkFormFeature.Action)
        case disappear
    }
    
    enum CancelID {
        case task
    }
    
    @Dependency(\.deleteBookmarkUseCase) private var deleteBookmarkUseCase
    @Dependency(\.updateBookmarkUseCase) private var updateBookmarkUseCase

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .detail(.delegate(.switchToEditMode)):
                guard case let .detail(bookmarkState) = state else { return .none }
                
                state = .edit(
                    BookmarkFormFeature.State(bookmark: bookmarkState.bookmark, formType: .update)
                )
                return .none
                
            case .detail(.delegate(.deleteBookmark)):
                return .run { [state] send in
                    if case let .detail(detailState) = state {
                        try await deleteBookmarkUseCase.execute(for: detailState.bookmark)
                        await send(.detail(.deleteBookmarkResponse(.success(()))))
                    }
                } catch: { error, send in
                    await send(.detail(.deleteBookmarkResponse(.failure(error))))
                }
                .cancellable(id: CancelID.task)
                
            case let .edit(.delegate(.save(bookmark))):
                return .run { send in
                    try await updateBookmarkUseCase.execute(for: bookmark)
                    await send(.edit(.saveBookmarkResponse(.success(()))))
                } catch: { error, send in
                    await send(.edit(.saveBookmarkResponse(.failure(error))))
                }
                .cancellable(id: CancelID.task)
                
            case .edit(.delegate(.switchToDetailMode)):
                guard case let .edit(bookmarkState) = state else { return .none }
                
                state = .detail(
                    BookmarkDetailFeature.State(bookmark: bookmarkState.bookmark)
                )
                
                return .none
                
            case .edit:
                return .none
                
            case .disappear:
                return .cancel(id: CancelID.task)
                
            default:
                return .none
            }
        }
        .ifCaseLet(\.detail, action: \.detail) {
            BookmarkDetailFeature()
        }
        .ifCaseLet(\.edit, action: \.edit) {
            BookmarkFormFeature()
        }
    }
    
}
