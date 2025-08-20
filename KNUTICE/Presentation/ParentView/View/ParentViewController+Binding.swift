//
//  ParentViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/11/25.
//

import Combine
import Foundation

extension ParentViewController {
    func bind() {
        viewModel.$shouldNavigateToMain
            .dropFirst()
            .sink(receiveValue: { [weak self] in
                if $0 {
                    self?.switchViewController()
                }
            })
            .store(in: &cancellables)
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
