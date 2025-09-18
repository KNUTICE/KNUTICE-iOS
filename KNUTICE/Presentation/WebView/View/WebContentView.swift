//
//  WebContentView.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/18/25.
//

import SwiftUI
import WebKit

@available(iOS 26, *)
struct WebContentView: View {
    @Environment(WebContentViewModel.self) private var viewModel
    
    let title: String
    
    init(title: String = "") {
        self.title = title
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ProgressView(value: viewModel.webPage.estimatedProgress)
                .tint(.accent2)
                .opacity(viewModel.webPage.isLoading ? 1 : 0)
            
            WebView(viewModel.webPage)
        }
        .onAppear {
            viewModel.load()
        }
        .navigationTitle(title)
    }
}

#Preview {
    if #available(iOS 26, *) {
        WebContentView(title: "Preview")
            .environment(WebContentViewModel(contentURL: "https://www.google.com"))
    } else {
        // Fallback on earlier versions
        EmptyView()
    }
}
