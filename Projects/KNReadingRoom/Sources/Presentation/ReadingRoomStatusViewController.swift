//
//  ReadingRoomStatusViewController.swift
//  KNReadingRoom
//
//  Created by 이정훈 on 4/8/26.
//

import KNDesignSystem
import KNUtility
import Foundation
import SnapKit
import SwiftUI
import UIKit
import WebKit

public final class ReadingRoomStatusViewController: UIViewController {
    private lazy var webView: WKWebView = {
        contentController.add(self, name: "bridge")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.tintColor = .black
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = KNDesignSystemAsset.primaryBackground.color
        webView.allowsBackForwardNavigationGestures = true
        webView.isOpaque = false
        webView.navigationDelegate = self
        
        return webView
    }()
    
    private let contentController = WKUserContentController()
    private var task: Task<Void, Never>?
    private var roomId: String?
    
    public init(roomId: String? = nil) {
        self.roomId = roomId
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("ReadingRoomStatusViewController init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = KNDesignSystemAsset.primaryBackground.color
        setupLayout()
        setupEdgeSwipeGesture()
        
        if let urlStr = Bundle.knReadingRoom.readingRoomStatusURL,
           let url = URL(string: urlStr) {
            webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData))
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        task?.cancel()
        contentController.removeAllScriptMessageHandlers()    // add(_:name:) 호출 시 발생할 수 있는 메모리 누수 방지
    }
    
    private func setupLayout() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupEdgeSwipeGesture() {
        // 모서리 스와이프 제스처 생성
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgeSwipe(_:)))
        edgePanGesture.edges = .left    // 좌측 끝에서 스와이프 인식
        edgePanGesture.delegate = self
        
        // view에 제스쳐 등록
        view.addGestureRecognizer(edgePanGesture)
        
        // 웹뷰의 스크롤 제스처와 모서리 제스처 모두 인식할 수 있도록 등록
        webView.scrollView.panGestureRecognizer.require(toFail: edgePanGesture)
    }
    
    @objc private func handleEdgeSwipe(_ gesture: UIScreenEdgePanGestureRecognizer) {
        // 슬라이드가 .recognized 되었을 때 동작
        if gesture.state == .recognized {
            if webView.canGoBack {
                webView.goBack()
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - WKNavigationDelegate
extension ReadingRoomStatusViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        task?.cancel()
        task = Task {
            do {
                try Task.checkCancellation()
                
                let fcmToken = try await FCMTokenManager.shared.getToken()
                let javaScriptString = """
                    \(Bundle.knReadingRoom.fcmTokenMethod)('\(fcmToken)');
                    \(Bundle.knReadingRoom.navigationMethod)('\(roomId ?? "")');
                """
                
                try await webView.evaluateJavaScript(javaScriptString)
            } catch {
                print("ReadingRoomStatusViewController: \(error)")
            }
        }
    }
}

// MARK: - WKScriptMessageHandler
extension ReadingRoomStatusViewController: WKScriptMessageHandler {
    public func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        if let body = message.body as? [String: String] {
            // CLOSE_WEBVIEW Event
            if body["type"] == "CLOSE_WEBVIEW" {
                navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - UIGestureRecongnizerDelegate
extension ReadingRoomStatusViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        // 모서리 제스처와 웹뷰 스크롤이 동시에 인식 되도록 허용
        return true
    }
}

// MARK: - Preview
#if DEBUG
#Preview {
    ReadingRoomStatusViewController(roomId: "ROOM1")
        .makePreview()
}
#endif
