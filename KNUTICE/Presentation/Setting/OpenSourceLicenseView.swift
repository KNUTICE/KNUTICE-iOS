//
//  OpenSourceLicenseView.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/16/24.
//

import SwiftUI

struct OpenSourceLicenseView: View {
    @State private var isLoading: Bool = false
    @State private var progress: Double = 0.0
    
    var body: some View {
        VStack(spacing: 0) {
            if isLoading {
                ProgressView(value: progress, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .scaleEffect(x: 1, y: 0.5, anchor: .trailing)
            }
            
            WebView(progress: $progress,
                    isLoading: $isLoading,
                    url: Bundle.main.openSourceURL)
        }
        .navigationTitle("오픈소스 라이선스")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#if DEBUG
#Preview {
    NavigationView {
        OpenSourceLicenseView()
    }
}
#endif
