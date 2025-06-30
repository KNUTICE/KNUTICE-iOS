//
//  ParentViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/11/25.
//

import Foundation
import RxSwift

extension ParentViewController {
    func bind() {
        viewModel.isFinishedTokenRegistration
            .bind(with: self) { owner, isFinished in
                if isFinished {
                    owner.switchViewController()
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    func switchViewController() {
        //이전 View Controller 제거
        children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
        
        //새로운 View Controller 삽입
        let tabBarViewController = UITabBarViewController(viewModel: TabBarViewModel())
        addChildVC(tabBarViewController)
    }
}
