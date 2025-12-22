//
//  BookmarkContainerView.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/14/25.
//

import ComposableArchitecture
import KNUTICECore
import SwiftUI

struct BookmarkContainerView: View {
    let store: StoreOf<BookmarkContainerFeature>
    let dismissAction: () -> Void
    
    var body: some View {
        ZStack {
            if case .detail = store.state, let detailStore = store.scope(state: \.detail, action: \.detail) {
                BookmarkDetail(store: detailStore, dismissAction: dismissAction)
            } else if case .edit = store.state, let formStore = store.scope(state: \.edit, action: \.edit) {
                BookmarkForm(store: formStore) {
                    store.send(.edit(.delegate(.switchToDetailMode)))
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
    NavigationStack {
        BookmarkContainerView(
            store: Store(
                initialState: BookmarkContainerFeature.State.detail(BookmarkDetailFeature.State(bookmark: Bookmark.sample))) {
                    BookmarkContainerFeature()
                }
        ) {
            // Dismiss Action
        }
    }
}
#endif
