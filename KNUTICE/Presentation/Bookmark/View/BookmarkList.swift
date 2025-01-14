//
//  BookmarkList.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/4/25.
//

import SwiftUI

struct BookmarkList: View {
    @StateObject private var viewModel: BookmarkListViewModel
    @State private var isShowingSheet: Bool = false
    
    init(viewModel: BookmarkListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        if let bookmarkList = viewModel.bookmarkList {
            List {
                ForEach(bookmarkList, id: \.self.notice.id) { bookmark in
                    ZStack {
                        NavigationLink {
                            BookmarkDetail(viewModel: AppDI.shared.makeBookmarkDetailViewModel(),
                                           bookmark: bookmark)
                        } label: {
                            EmptyView()
                        }
                        
                        BookmarkListRow(bookmark: bookmark)
                    }
                    .listRowBackground(Color.mainBackground)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.fetchBookmarks(delay: 1)
            }
            .background(.mainBackground)
            .overlay {
                if bookmarkList.isEmpty {
                    EmptySectionView(content: "북마크가 존재하지 않아요 :(")
                }
            }
        } else {
            SpinningIndicator()
                .task {
                    if viewModel.bookmarkList == nil {
                        await viewModel.fetchBookmarks(delay: 0)
                    }
                }
        }
    }
}

fileprivate struct EmptySectionView: View {
    let content: String
    
    var body: some View {
        Text(content)
            .foregroundStyle(.gray)
            .frame(height: 200)
    }
}

#Preview {
    NavigationStack {
        BookmarkList(viewModel: AppDI.shared.makeBookmarkListViewModel())
    }
}
