//
//  BaseWebView.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/16/24.
//

import WebKit
import SwiftUI

public struct BaseWebView: UIViewRepresentable {
    @Binding private var progress: Double
    @Binding private var isLoading: Bool
    
    private let url: String
    private let webView = WKWebView()
    
    public init(
        progress: Binding<Double>,
        isLoading: Binding<Bool>,
        url: String
    ) {
        _progress = progress
        _isLoading = isLoading
        self.url = url
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    public func makeUIView(context: Context) -> some UIView {
        guard let url = URL(string: url) else {
            return webView
        }
        
        webView.tintColor = .black
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData))
        
        return webView
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {}
}

extension BaseWebView {
    public final class Coordinator: NSObject, WKNavigationDelegate {
        private let parent: BaseWebView
        
        init(parent: BaseWebView) {
            self.parent = parent
        }
        
        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.parent.isLoading = false
            }
            
            parent.progress = 1.0
        }
        
        public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.progress = Double(webView.estimatedProgress)
        }
    }
}
