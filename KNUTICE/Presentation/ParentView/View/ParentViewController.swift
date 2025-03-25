//
//  ParentViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 3/11/25.
//

import UIKit
import RxSwift

final class ParentViewController: UIViewController {
    let viewModel: ParentViewModel
    let disposeBag: DisposeBag = DisposeBag()
    
    init(viewModel: ParentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let storyboard = UIStoryboard(name: "LoadingLaunchScreen", bundle: nil)
        let loadingViewController = storyboard.instantiateViewController(identifier: "VC1")
        addChildVC(loadingViewController)
        viewModel.subscribeToFCMToken()
        bind()
    }
    
    func addChildVC(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
