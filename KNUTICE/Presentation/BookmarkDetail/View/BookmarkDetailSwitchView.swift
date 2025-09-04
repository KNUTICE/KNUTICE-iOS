//
//  BookmarkDetailSwitchView.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/14/25.
//

import KNUTICECore
import SwiftUI

struct BookmarkDetailSwitchView: View {
    enum BookmarkViewMode {
        case detailView
        case editView
    }
    
    @StateObject private var viewModel: BookmarkFormViewModel
    @State private var selectedMode: BookmarkViewMode = .detailView
    @Environment(\.dismiss) private var dismiss
    
    init(viewModel: BookmarkFormViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if selectedMode == .detailView {
                BookmarkDetail(selectedMode: $selectedMode)
                    .environmentObject(viewModel)
            } else {
                BookmarkForm(for: .update) {
                    withAnimation(.easeInOut) {
                        selectedMode = .detailView
                    }
                }
                .environmentObject(viewModel)
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
        BookmarkDetailSwitchView(
            viewModel: BookmarkFormViewModel(bookmark: Bookmark.sample)
        )
    }
}
#endif
