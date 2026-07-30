//
//  ParentViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/11/25.
//

import Combine
import Factory
import UIKit

final class ParentViewController: UIViewController {
    @Injected(\.parentViewModel) var viewModel
    var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let storyboard = UIStoryboard(name: "LoadingLaunchScreen", bundle: nil)
        let loadingViewController = storyboard.instantiateViewController(identifier: "LoadingLaunchViewController")
        addChildVC(loadingViewController)
        bind()
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
}
