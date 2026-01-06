//
//  UIViewController+Preview.swift
//  KNUTICE
//
//  Created by 이정훈 on 5/14/24.
//

import SwiftUI

#if DEBUG
extension UIViewController {
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
