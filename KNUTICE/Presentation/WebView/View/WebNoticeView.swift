//
//  WebNoticeView.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/11/25.
//

import SwiftUI
import WebKit

@available(iOS 26, *)
struct WebNoticeView: View {
    @Environment(WebNoticeViewModel.self) private var viewModel
    @State private var isShowingSheet: Bool = false
    
    var body: some View {
        ZStack {
            WebView(
                viewModel.page
            )
            .ignoresSafeArea(.all, edges: .bottom)
            .onAppear {
                viewModel.loadContent()
            }
            .onChange(of: viewModel.page.isLoading) {
                if !$0 {
                    viewModel.injectScript()
                }
            }
            .opacity(viewModel.isShowingWebView ? 1 : 0)
            
            PlusButton(isShowingSheet: $isShowingSheet)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                .opacity(viewModel.page.isLoading ? 0 : 1)
            
            ProgressView()
                .scaleEffect(2.0)
                .progressViewStyle(.circular)
                .opacity(viewModel.page.isLoading ? 1 : 0)
        }
        .sheet(isPresented: $isShowingSheet) {
            NavigationStack {
                BookmarkForm(for: .create) {
                    isShowingSheet.toggle()
                }
                .environmentObject(
                    BookmarkFormViewModel(bookmark: Bookmark(notice: viewModel.notice, memo: ""))
                )
            }
        }
        .toolbar {
            if let url = URL(string: viewModel.notice.contentUrl) {
                ShareLink(item: url)
            }
        }
    }
}

@available(iOS 26, *)
fileprivate struct PlusButton: View {
    @Binding var isShowingSheet: Bool
    
    var body: some View {
        Button {
            isShowingSheet.toggle()
        } label: {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 15, height: 15)
                .padding([.top, .bottom])
                .padding([.leading, .trailing], 10)
        }
        .buttonStyle(.glass)
    }
}

#if DEBUG
#Preview {
    if #available(iOS 26, *) {
        NavigationStack {
            WebNoticeView()
                .environment(WebNoticeViewModel(notice: Notice.generalNoticesSampleData.first!))
        }
    } else {
        // Fallback on earlier versions
    }
}
#endif
