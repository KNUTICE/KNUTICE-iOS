//
//  MealView.swift
//  KNMeal
//
//  Created by 이정훈 on 2/15/26.
//

import SwiftUI
import WebKit

public struct MealView: UIViewRepresentable {
    private let webView: WKWebView = WKWebView()
    
    public init() {}
    
    public func makeUIView(context: Context) -> some UIView {
        guard let url = URL(string: Bundle.module.baseURL) else {
            return webView
        }
        
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData))
        
        return webView
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {}
}

#Preview {
    MealView()
}
