//
//  BookmarkDetailSwitchView.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/14/25.
//

import SwiftUI

struct BookmarkDetailSwitchView: View {
    enum BookmarkViewMode {
        case detailView
        case editView
    }
    
    @State private var selectedMode: BookmarkViewMode = .detailView
    @Environment(\.dismiss) private var dismiss
    
    let bookmark: Bookmark
    
    var body: some View {
        Group {
            if selectedMode == .detailView {
                BookmarkDetail(viewModel: AppDI.shared.makeBookmarkDetailViewModel(),
                               bookmark: bookmark,
                               selectedMode: $selectedMode)
            } else {
                BookmarkForm(viewModel: AppDI.shared.makeBookmarkEditFormViewModel(from: bookmark),
                             notice: bookmark.notice) {
                    withAnimation(.easeInOut) {
                        selectedMode = .detailView
                    }
                }
                .navigationBarBackButtonHidden(true)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        BookmarkDetailSwitchView(bookmark: Bookmark.sample)
    }
}
#endif
