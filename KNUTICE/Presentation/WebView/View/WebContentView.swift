//
//  SimpleWebView.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/11/25.
//

import SwiftUI
import WebKit

@available(iOS 26, *)
struct WebContentView: View {
    @Environment(WebContentViewModel.self) private var viewModel
    
    var body: some View {
        ZStack {
            WebView(
                viewModel.page
            )
            .ignoresSafeArea(.all, edges: .bottom)
            .task {
                await viewModel.loadContent()
            }
            
            ProgressView()
                .scaleEffect(2.0)
                .progressViewStyle(.circular)
                .opacity(viewModel.page.isLoading ? 1 : 0)
        }
    }
}

#Preview {
    if #available(iOS 26, *) {
        WebContentView()
            .environment(WebContentViewModel(contentURL: "https://www.google.com"))
    } else {
        // Fallback on earlier versions
    }
}
