//
//  ParentViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/11/25.
//
import Combine
import Foundation
import KNUTICECore
import UIKit

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
        
        let majorStr = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedMajor.rawValue)
        let majorCategory = MajorCategory(rawValue: majorStr ?? "")
        let viewController: UIViewController
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewController = UITabBarViewController(
                viewModel: TabBarViewModel(category: majorCategory)
            )
        } else {
            //새로운 View Controller 삽입
            viewController = UINavigationController(
                rootViewController: UITabBarViewController(
                    viewModel: TabBarViewModel(category: majorCategory)
                )
            )
        }
        addChildVC(viewController)
    }
}
