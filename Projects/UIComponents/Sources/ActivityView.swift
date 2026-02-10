//
//  ActivityView.swift
//  UIComponents
//
//  Created by 이정훈 on 2/10/26.
//

import SwiftUI
import UIKit

public struct ActivityView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    
    public let activityItmes: [Any]
    public let applicationActivities: [UIActivity]? = nil
    
    public init(isPresented: Binding<Bool>, activityItmes: [Any]) {
        _isPresented = isPresented
        self.activityItmes = activityItmes
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let activityViewController = UIActivityViewController(
            activityItems: activityItmes,
            applicationActivities: applicationActivities
        )
        
        if isPresented && uiViewController.presentedViewController == nil {
            uiViewController.present(activityViewController, animated: true)
        }
        activityViewController.completionWithItemsHandler = { (_, _, _, _) in
            isPresented = false
        }
    }
}

