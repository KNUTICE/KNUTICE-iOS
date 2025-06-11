//
//  WebNoticeViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/11/25.
//

import Combine
import WebKit

@available(iOS 18.4, *)
@MainActor
@Observable
final class WebNoticeViewModel {
    let page: WebPage = WebPage()
    var isShowingWebView: Bool = false
    @ObservationIgnored let notice: Notice
    
    init(notice: Notice) {
        self.notice = notice
    }
    
    func loadContent() {
        guard let contentURL = URL(string: notice.contentUrl) else { return }
        
        page.load(URLRequest(url: contentURL, cachePolicy: .returnCacheDataElseLoad))
    }
    
    func injectScript() {
        Task {
            do {
                try await page.callJavaScript("document.getElementById(\"header\").style.display='none';document.getElementById(\"footer\").style.display='none';")
                isShowingWebView = true
            } catch {
                print(error)
            }
        }
    }
}
