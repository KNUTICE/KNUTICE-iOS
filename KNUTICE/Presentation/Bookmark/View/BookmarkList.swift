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
        List {
            ForEach(viewModel.bookmarkList) { bookmark in
                ZStack {
                    NavigationLink {
                        
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
        .background(.mainBackground)
        .overlay {
            if viewModel.bookmarkList.isEmpty {
                EmptySectionView(content: "북마크가 존재하지 않아요 :(")
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
        BookmarkList(viewModel: BookmarkListViewModel())
    }
}
