//
//  MealView.swift
//  KNMeal
//
//  Created by 이정훈 on 2/15/26.
//

import KNDesignSystem
import KNDomain
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
        
        guard let url = URL(string: Bundle.knMeal.baseURL) else {
            return webView
        }
        
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = KNDesignSystemAsset.primaryBackground.color
        webView.isOpaque = false
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData))
        
        return webView
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    public class Coordinator: NSObject, WKNavigationDelegate {
        private let parent: MealView
        
        public init(parent: MealView) {
            self.parent = parent
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript(Bundle.knMeal.bridgingMethod + "(\"\(parent.cafeteria.rawValue)\");")
        }
    }
}

#Preview {
    MealView()
}
