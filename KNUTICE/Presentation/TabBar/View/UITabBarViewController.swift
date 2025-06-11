//
//  UITabBarViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/4/25.
//

import UIKit
import SwiftUI
import RxSwift

final class UITabBarViewController: UITabBarController {
    private let mainViewController: UIViewController = {
        let viewController = MainTableViewController()
        viewController.tabBarItem.image = UIImage(systemName: "house")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        viewController.tabBarItem.title = "홈"
        
        return viewController
    }()
    private let bookmarkViewController: UIViewController = {
        let viewController = BookmarkTableViewController()
        viewController.tabBarItem.image = UIImage(systemName: "bookmark")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        viewController.tabBarItem.title = "북마크"
        
        return viewController
    }()
    private let searchViewController: UIViewController = {
        let viewController = UINavigationController(
            rootViewController: SearchResultsTableViewController()
        )
        viewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        if UIDevice.current.userInterfaceIdiom  == .phone {
            viewController.tabBarItem.title = "검색"
        }
        
        return viewController
    }()
    let viewModel: TabBarViewModel
    let disposeBag: DisposeBag = .init()
    
    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        setViewControllers([mainViewController, bookmarkViewController, searchViewController], animated: true)
        
        bind()
        viewModel.fetchPushNoticeIfExists()
        
        if UserDefaults.standard.double(forKey: "noShowPopupDate") < Date().timeIntervalSince1970 {
            viewModel.fetchMainPopupContent()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension UITabBarViewController {
    func bind() {
        viewModel.mainPopupContent
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .bind(onNext: { [weak self] in
                if let popupContent = $0, let self = self {
                    let bottomModal = BottomModal(content: popupContent)
                    self.view.addSubview(bottomModal)
                    bottomModal.setupLayout()
                    UIView.animate(withDuration: 0.5) {
                        bottomModal.alpha = 1
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.pushNotice
            .bind(onNext: { [weak self] pushNotice in
                guard let pushNotice else { return }
                
                DispatchQueue.main.async {
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.navigationController?.pushViewController(WebViewController(notice: pushNotice), animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIApplication.willEnterForegroundNotification)
            .bind { [weak self] _ in
                self?.viewModel.fetchPushNoticeIfExists()
            }
            .disposed(by: disposeBag)
    }
}


#if DEBUG
struct UITabBarViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: UITabBarViewController(viewModel: TabBarViewModel()))
            .makePreview()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
