//
//  ReadingRoomStatusView.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 2/1/26.
//

import KNDesignSystem
import KNUtility
import WebKit
import SwiftUI

public struct ReadingRoomStatusView: UIViewRepresentable {
    @Environment(\.dismiss) private var dismiss
    
    public init() {}

    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    public func makeUIView(context: Context) -> some UIView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "bridge")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.tintColor = .black
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = KNDesignSystemAsset.primaryBackground.color
        webView.isOpaque = false
        webView.navigationDelegate = context.coordinator
        
        guard let urlStr = Bundle.knReadingRoom.readingRoomStatusURL,
              let url = URL(string: urlStr) else {
            return webView
        }
        
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData))
        
        return webView
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {}

}

extension ReadingRoomStatusView {
    public class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        private let parent: ReadingRoomStatusView
        private var task: Task<Void, Never>?
        
        public init(parent: ReadingRoomStatusView) {
            self.parent = parent
        }
        
        deinit {
            task?.cancel()
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            task?.cancel()
            task = Task {
                do {
                    try Task.checkCancellation()
                    
                    let fcmToken = try await FCMTokenManager.shared.getToken()
                    let javaScriptString = """
                        \(Bundle.knReadingRoom.bridgingMethod)('\(fcmToken)');
                    """
                    
                    webView.evaluateJavaScript(javaScriptString, completionHandler: nil)
                } catch {
                    print("ReadingRoomStatusView.Coordinator: \(error)")
                }
                
            }
        }
        
        public func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            if let body = message.body as? [String: String] {
                // CLOSE_WEBVIEW Event
                if body["type"] == "CLOSE_WEBVIEW" {
                    parent.dismiss()
                }
            }
        }
    }
}

#Preview {
    ReadingRoomStatusView()
}
