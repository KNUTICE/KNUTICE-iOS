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
    
    public let activityItems: [Any]
    public let applicationActivities: [UIActivity]? = nil
    
    public init(isPresented: Binding<Bool>, activityItems: [Any]) {
        _isPresented = isPresented
        self.activityItems = activityItems
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard isPresented else {
            if uiViewController.presentedViewController != nil {
                uiViewController.dismiss(animated: true)
            }
            return
        }
        
        guard uiViewController.presentedViewController == nil else { return }
        
        let activityViewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            isPresented = false
        }
        
        // iPad Popover 대응
        if UIDevice.current.userInterfaceIdiom == .pad, let popover = activityViewController.popoverPresentationController {
            popover.sourceView = uiViewController.view
            popover.sourceRect = CGRect(
                x: uiViewController.view.bounds.midX,
                y: uiViewController.view.bounds.midY,
                width: 0,
                height: 0
            )
            popover.permittedArrowDirections = []
        }
        
        uiViewController.present(activityViewController, animated: true)
    }
}
