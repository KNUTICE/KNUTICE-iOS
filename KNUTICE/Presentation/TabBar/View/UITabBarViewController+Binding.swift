//
//  UITabBarViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import UIKit

extension UITabBarViewController {
    func binding() {
        viewModel
            .mainPopupContent
            .subscribe { [weak self] in
                if let element = $0.element, let popupContent = element, let self = self {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve) {
                            let bottomModal = BottomModal(content: popupContent)
                            self.view.addSubview(bottomModal)
                            bottomModal.setLayout()
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
