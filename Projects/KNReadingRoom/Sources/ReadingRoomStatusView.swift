//
//  ReadingRoomStatusView.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 2/1/26.
//

import KNUtility
import WebKit
import SwiftUI

public struct ReadingRoomStatusView: UIViewRepresentable {
    
    private let url: String
    private let webView = WKWebView()
    
    public init(url: String) {
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

extension ReadingRoomStatusView {
    public class Coordinator: NSObject, WKNavigationDelegate {
        private let parent: ReadingRoomStatusView
        private(set) var task: Task<Void, Never>?
        
        public init(parent: ReadingRoomStatusView) {
            self.parent = parent
        }
        
        deinit {
            task?.cancel()
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            task = Task {
                do {
                    try Task.checkCancellation()
                    
                    let fcmToken = try await FCMTokenManager.shared.getToken()
                    let javaScriptString = "window.setFcmToken(\(fcmToken))"
                    
                    try await parent.webView.evaluateJavaScript(javaScriptString)
                } catch {
                    print(error)
                }
                
            }
        }
    }
}

#Preview {
    ReadingRoomStatusView(url: Bundle.module.readingRoomStatusURL!)
}
