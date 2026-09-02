//
//  ParentViewController+Binding.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/11/25.
//
import Combine
import Foundation
import KNDomain
import KNUtility
import UIKit

extension ParentViewController {
    func bindMainNavigationState() {
        viewModel.$shouldNavigateToMain
            .combineLatest(viewModel.$didCompleteMajorDataMigration)
            .dropFirst(2)
            .sink(receiveValue: { [weak self] shouldNavigateToMain, didCompleteMajorDataMigration in
                if shouldNavigateToMain && didCompleteMajorDataMigration {
                    //FIXME: OptimizationLoadingView 표시보다 Main 화면 전환이 더 먼저 발생함
                    self?.switchViewController()
                }
            })
            .store(in: &cancellables)
    }
    
    func bindMigrationState() {
        viewModel.$isMigratingMajorData
            .dropFirst()
            .delay(for: .seconds(3), scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isMigratingMajorData in
                if isMigratingMajorData {
                    self?.addOptimizationLoadingView()
                } else {
                    self?.removeOptimizationLoadingView()
                }
            })
            .store(in: &cancellables)
    }
    
    func switchViewController() {
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            let majorCategory = await viewModel.fetchMajorCategory()
            let viewController = UITabBarViewController(
                viewModel: TabBarViewModel(category: majorCategory)
            )
            
            // 새로운 View Controller 삽입
            navigationController?.setViewControllers([viewController], animated: false)
            
            // 메인 화면의 진입을 알리기 위한 Notification 전송
            // 딥링크 Cold Start 시, 메인 화면 이동이 완료된 후 딥링크 이동
            NotificationCenter.default.post(name: Notification.Name.didFinishLoading, object: nil)
        }
    }
}
