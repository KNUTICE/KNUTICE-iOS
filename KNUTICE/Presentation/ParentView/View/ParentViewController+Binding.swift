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
        let majorStr = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedMajor.rawValue)
        let majorCategory = MajorCategory(rawValue: majorStr ?? "")
        let viewController = UITabBarViewController(
            viewModel: TabBarViewModel(category: majorCategory)
        )
        
        //새로운 View Controller 삽입
        navigationController?.setViewControllers([viewController], animated: true)
    }
}
