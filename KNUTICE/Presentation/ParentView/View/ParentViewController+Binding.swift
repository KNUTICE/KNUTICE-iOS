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
        let majorStr = UserDefaults.shared?.string(forKey: UserDefaultsKeys.selectedMajor.rawValue) ?? ""
        let majorCategory = MajorCategory(rawValue: majorStr)
        let viewController = UITabBarViewController(
            viewModel: TabBarViewModel(category: majorCategory)
        )
        
        //새로운 View Controller 삽입
        navigationController?.setViewControllers([viewController], animated: false)
        
        // 메인 화면의 진입을 알리기 위한 Notification 전송
        // 딥링크 Cold Start 시, 메인 화면 이동이 완료된 후 딥링크 이동
        NotificationCenter.default.post(name: Notification.Name.didFinishLoading, object: nil)
    }
}
