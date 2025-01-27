//
//  UITabBarViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import UIKit
import RxSwift

extension UITabBarViewController {
    func binding() {
        viewModel
            .mainPopupContent
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] in
                if let element = $0.element, let popupContent = element, let self = self {
                    UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve) {
                        let bottomModal = BottomModal(content: popupContent)
                        self.view.addSubview(bottomModal)
                        bottomModal.setupLayout()
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
