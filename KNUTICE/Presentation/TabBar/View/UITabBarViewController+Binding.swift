//
//  UITabBarViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/22/25.
//

import RxSwift

extension UITabBarViewController {
    func binding() {
        viewModel
            .mainPopupContent
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { [weak self] in
                if let element = $0.element, let popupContent = element, let self = self {
                    let bottomModal = BottomModal(content: popupContent)
                    self.view.addSubview(bottomModal)
                    bottomModal.setupLayout()
                    UIView.animate(withDuration: 0.5) {
                        bottomModal.alpha = 1
                    }
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.pushNotice)
            .subscribe(onNext: { [weak self] notification in
                guard let notice = notification.object as? Notice else {
                    return
                }
                self?.navigationController?.popToRootViewController(animated: true)
                self?.navigationController?.pushViewController(WebViewController(notice: notice), animated: true)
                UserDefaults.standard.set(nil, forKey: "pushNotice")
            })
            .disposed(by: disposeBag)
    }
}
