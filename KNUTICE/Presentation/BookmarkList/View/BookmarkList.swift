//
//  BookmarkList.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/4/25.
//

import SwiftUI

struct BookmarkList: View {
    @StateObject private var viewModel: BookmarkListViewModel
    
    init(viewModel: BookmarkListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        if let bookmarkList = viewModel.bookmarkList {
            VStack(spacing: 0) {
                BookmarkListNavBar()
                
                List {
                    if !bookmarkList.isEmpty {
                        Text("개수(\(bookmarkList.count))")
                            .frame(height: 3)
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(.gray)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.mainBackground)
                            .offset(y: 10)
                    }
                    
                    ForEach(bookmarkList, id: \.self.notice.id) { bookmark in
                        ZStack {
                            NavigationLink {
                                BookmarkDetailSwitchView(bookmark: bookmark)
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
                .onAppear {
                    if !viewModel.isBindingWithNotification {
                        viewModel.bindingRefreshNotification()
                    }
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

fileprivate struct BookmarkListNavBar: View {
    var body: some View {
        HStack {
            Text("북마크")
                .font(.title2)
                .bold()
            
            Spacer()
            
            NavigationLink {
                SettingView(viewModel: AppDI.shared.makeSettingViewModel())
            } label: {
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(width: 22, height: 22)
            }
            .offset(x: -1.5)
        }
        .frame(height: 44)
        .padding([.leading, .trailing], 16)
        .background(.mainBackground)
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
