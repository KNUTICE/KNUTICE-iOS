//
//  ContentWebView.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/16/24.
//

import SwiftUI

struct ContentWebView: View {
    @State private var isLoading: Bool = false
    @State private var progress: Double = 0.0
    
    let navigationTitle: String
    let contentURL: String
    
    var body: some View {
        VStack(spacing: 0) {
            if isLoading {
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(.blue)
                    .scaleEffect(x: 1, y: 0.5, anchor: .trailing)
            } else {
                Color(.white)
                    .frame(height: 4)
            }
            
            WebView(progress: $progress,
                    isLoading: $isLoading,
                    url: contentURL)
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationView {
        ContentWebView(navigationTitle: "오픈소스 라이선스", contentURL: Bundle.main.openSourceURL)
    }
}
#endif
