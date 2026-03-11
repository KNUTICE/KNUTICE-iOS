//
//  MealView.swift
//  KNMeal
//
//  Created by 이정훈 on 2/15/26.
//

import KNDesignSystem
import KNUtility
import SwiftUI
import WebKit

public struct MealView: UIViewRepresentable {
    private let cafeteria: CafeteriaCategory
    
    public init(cafeteria: CafeteriaCategory = CafeteriaCategory.studentCafeteria) {
        self.cafeteria = cafeteria
    }
    
    public func makeUIView(context: Context) -> some UIView {
        let webView: WKWebView = WKWebView()
        
        guard let url = URL(string: Bundle.module.baseURL) else {
            return webView
        }
        
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = KNDesignSystemAsset.primaryBackground.color
        webView.isOpaque = false
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData))
        webView.evaluateJavaScript("window.setCafeteriaType(\(cafeteria.rawValue));")
        
        return webView
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {}
}

#Preview {
    MealView()
}
