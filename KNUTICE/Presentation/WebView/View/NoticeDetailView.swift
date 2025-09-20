//
//  NoticeDetailView.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/19/25.
//

import KNUTICECore
import SwiftUI
import WebKit

@available(iOS 26, *)
struct NoticeDetailView: View {
    @Environment(NoticeDetailViewModel.self) private var viewModel
    @State private var isShowingBookmarkForm: Bool = false
    
    var body: some View {
        ZStack {
            Group {
                WebView(viewModel.webPage)
                
                Button {
                    isShowingBookmarkForm = true
                } label: {
                    Image(systemName: "plus")
                        .bold()
                        .padding()
                }
                .tint(.accent2)
                .glassEffect(in: Circle())
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding([.trailing, .bottom])
            }
            .opacity(!viewModel.webPage.isLoading && !viewModel.didHideIrrelevantElements ? 1 : 0)
            
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(1.8)
                .opacity(viewModel.webPage.isLoading ? 1 : 0)
        }
        .onAppear {
            if let _ = viewModel.notice {
                viewModel.load()
            } else {
                viewModel.fetchContent()
            }
        }
        .onDisappear {
            for task in viewModel.tasks {
                task.cancel()
            }
        }
        .onChange(of: viewModel.webPage.isLoading) {
            if !viewModel.webPage.isLoading {
                viewModel.hideIrrelevantElements()
            }
        }
        .sheet(isPresented: $isShowingBookmarkForm) {
            if let notice = viewModel.notice {
                NavigationStack {
                    BookmarkForm(for: .create) {
                        isShowingBookmarkForm = false
                    }
                    .environmentObject(
                        BookmarkViewModel(bookmark: Bookmark(notice: notice, memo: ""))
                    )
                }
            }
        }
        .toolbar {
            if let notice = viewModel.notice, let url = URL(string: notice.contentUrl) {
                ShareLink(item: url)
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        if #available(iOS 26, *) {
            NoticeDetailView()
                .environment(
                    NoticeDetailViewModel(notice: Notice.generalNoticesSampleData.first!)
                )
        } else {
            EmptyView()
        }
    }
}
#endif
