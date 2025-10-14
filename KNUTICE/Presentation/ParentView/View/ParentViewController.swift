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
        let loadingViewController = storyboard.instantiateViewController(identifier: "VC1")
        addChildVC(loadingViewController)
        viewModel.subscribeToFCMToken()
        viewModel.subscribeToNotificationAuthorizationStatus()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.tokenUploadTask?.cancel()
        viewModel.navigationFallbackTask?.cancel()
    }
    
    func addChildVC(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
