//
//  WebView.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/16/24.
//

import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    @Binding var progress: Double
    @Binding var isLoading: Bool
    
    let url: String
    private let webView = WKWebView()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> some UIView {
        guard let url = URL(string: url) else {
            return webView
        }
        
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

extension WebView {
    final class Coordinator: NSObject, WKNavigationDelegate {
        private let parent: WebView
        
        init(parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.parent.isLoading = false
            }
            
            parent.progress = 1.0
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.progress = Double(webView.estimatedProgress)
        }
    }
}