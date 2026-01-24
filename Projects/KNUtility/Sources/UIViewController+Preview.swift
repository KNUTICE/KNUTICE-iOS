//
//  UIViewController+Preview.swift
//  KNUtility
//
//  Created by 이정훈 on 1/21/26.
//

import SwiftUI

#if DEBUG
public extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
    
    func makePreview() -> some View {
        Preview(viewController: self)
    }
}
#endif
