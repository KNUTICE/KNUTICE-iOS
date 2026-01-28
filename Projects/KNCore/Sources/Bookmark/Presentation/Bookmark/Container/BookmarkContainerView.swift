//
//  BookmarkContainerView.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/14/25.
//

import ComposableArchitecture
import SwiftUI

public struct BookmarkContainerView: View {
    let store: StoreOf<BookmarkContainerFeature>
    let dismissAction: () -> Void
    
    public init(store: StoreOf<BookmarkContainerFeature>, dismissAction: @escaping () -> Void) {
        self.store = store
        self.dismissAction = dismissAction
    }
    
    public var body: some View {
        ZStack {
            if case .detail = store.state, let detailStore = store.scope(state: \.detail, action: \.detail) {
                BookmarkDetail(store: detailStore, dismissAction: dismissAction)
            } else if case .edit = store.state, let formStore = store.scope(state: \.edit, action: \.edit) {
                BookmarkForm(store: formStore) {
                    if case let .edit(bookmarkState) = store.state {
                        store.send(.edit(.delegate(.switchToDetailMode(bookmarkState.bookmark))))
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible)
        .onDisappear {
            store.send(.disappear)
        }
        .animation(.easeInOut, value: store.state)
    }
}

#if DEBUG
#Preview {
    var bookmarkDetailStore: StoreOf<BookmarkContainerFeature> {
        Store(
            initialState: BookmarkContainerFeature.State.detail(
                BookmarkDetailFeature.State(
                    bookmark: Bookmark.sample,
                    nttId: Bookmark.sample.identity)
            )
        ) {
            BookmarkContainerFeature()
        }
    }
    
    NavigationStack {
        BookmarkContainerView(store: bookmarkDetailStore) {
            // Dismiss Action
        }
    }
}
#endif
