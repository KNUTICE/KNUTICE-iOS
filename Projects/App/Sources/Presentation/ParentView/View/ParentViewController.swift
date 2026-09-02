//
//  ParentViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/11/25.
//

import Combine
import Factory
import SwiftUI
import UIKit

final class ParentViewController: UIViewController {
    @Injected(\.parentViewModel) var viewModel
    var cancellables: Set<AnyCancellable> = []
    private var optimizationLoadingViewController: UIHostingController<OptimizationLoadingView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let storyboard = UIStoryboard(name: "LoadingLaunchScreen", bundle: nil)
        let loadingViewController = storyboard.instantiateViewController(identifier: "LaunchViewController")
        addChildVC(loadingViewController)
        bindMainNavigationState()
        bindMigrationState()
        viewModel.subscribeToFCMToken()
        viewModel.subscribeToNotificationAuthorizationStatus()
        viewModel.prepareAppConfiguration()
        viewModel.migrateMajorDataIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.navigationFallbackTask?.cancel()
    }
    
    func addChildVC(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
    
    func addOptimizationLoadingView() {
        guard optimizationLoadingViewController == nil else { return }

        let hostingViewController = UIHostingController(rootView: OptimizationLoadingView())
        optimizationLoadingViewController = hostingViewController
        addChildVC(hostingViewController)
    }
    
    func removeOptimizationLoadingView() {
        guard let hostingViewController = optimizationLoadingViewController else { return }

        hostingViewController.willMove(toParent: nil)
        hostingViewController.view.removeFromSuperview()
        hostingViewController.removeFromParent()
        optimizationLoadingViewController = nil
    }
}
