//
//  WebContentViewModel.swift
//  KNUTICE
//
//  Created by 이정훈 on 9/18/25.
//

import Foundation
import WebKit

@available(iOS 26, *)
@MainActor
@Observable
class WebContentViewModel {
    let webPage: WebPage = WebPage()
    
    @ObservationIgnored
    private let contentURL: String?
    
    init(contentURL: String?) {
        self.contentURL = contentURL
    }
    
    func load() {
        guard let contentURL, let url = URL(string: contentURL) else { return }
        
        webPage.load(URLRequest(url: url))
    }
}
