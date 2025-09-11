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
        bind()
        
        #if DEBUG
        // FIXME: Screen transition issue due to a device token generation bug in the Xcode 26 simulator
        viewModel.shouldNavigateToMain = true
        #endif
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.task?.cancel()
    }
    
    func addChildVC(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
