//
//  ParentViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/11/25.
//
import Combine
import Foundation
import KNUtility
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
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            let viewController = UITabBarViewController(viewModel: TabBarViewModel())
            
            // 메인 화면을 표시
            navigationController?.setViewControllers([viewController], animated: false)
            
            // 메인 화면의 진입을 알리기 위한 Notification 전송
            // 딥링크 Cold Start 시, 메인 화면 이동이 완료된 후 딥링크 이동
            NotificationCenter.default.post(name: Notification.Name.didFinishLoading, object: nil)
        }
    }
}
