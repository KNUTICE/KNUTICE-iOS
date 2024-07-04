//
//  WebViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 7/4/24.
//

import UIKit
import WebKit
import SwiftUI

final class WebViewController: UIViewController {
    let webView: WKWebView = WKWebView()
    private let url: String
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupAttribute()
        loadPage(url)
    }
}

extension WebViewController: WKNavigationDelegate {
    //MARK: - 롱터치 방지
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none'", completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none'", completionHandler: nil)
    }
}

//MARK: - Preview
struct WebViewControllerPreview: PreviewProvider {
    static var previews: some View {
        WebViewController(url: "https://www.ut.ac.kr/")
            .makePreview()
    }
}
