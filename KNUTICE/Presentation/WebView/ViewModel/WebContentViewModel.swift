//
//  WebContentViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 6/11/25.
//

import Combine
import WebKit

@available(iOS 18.4, *)
@MainActor
@Observable
final class WebContentViewModel {
    let page: WebPage = WebPage()
    @ObservationIgnored let contentURL: String
    
    init(contentURL: String) {
        self.contentURL = contentURL
    }
    
    func loadContent() async {
        guard let url = URL(string: contentURL) else { return }
        
        page.load(URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad))
    }
}
