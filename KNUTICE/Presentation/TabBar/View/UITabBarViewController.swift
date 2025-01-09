//
//  UITabBarViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/4/25.
//

import UIKit
import SwiftUI

final class UITabBarViewController: UITabBarController {
    private let mainViewController = MainViewController(viewModel: AppDI.shared.makeMainViewModel())
    private let reminderViewController = UIHostingController(
        rootView: BookmarkList(viewModel: AppDI.shared.makeReminderListViewModel())
    )
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBar(for: selectedIndex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewControllers([mainViewController, reminderViewController], animated: true)
        setupTabBar()
        setupShadowView()
        self.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .customBackground
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

extension UITabBarViewController {
    private func setupTabBar() {
        mainViewController.tabBarItem.image = UIImage(systemName: "house")
        mainViewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        mainViewController.tabBarItem.title = "홈"
        
        reminderViewController.tabBarItem.image = UIImage(systemName: "bookmark")
        reminderViewController.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        reminderViewController.tabBarItem.title = "북마크"
        
        tabBar.backgroundColor = .tabBar
        tabBar.layer.cornerRadius = 15
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .tabBar
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func setupShadowView() {
        let shadowView = UIView(frame: .zero)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.backgroundColor = .tabBar
        shadowView.layer.cornerRadius = 15
        shadowView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.borderWidth = 1
        shadowView.layer.borderColor = UIColor.tabBar.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.shadowRadius = 15
        
        view.addSubview(shadowView)
        view.bringSubviewToFront(tabBar)
        shadowView.snp.makeConstraints { make in
            make.width.equalTo(tabBar.snp.width)
            make.height.equalTo(tabBar.snp.height)
            make.centerX.equalTo(tabBar.snp.centerX)
            make.bottom.equalTo(tabBar.snp.bottom)
        }
    }
}

#if DEBUG
struct UITabBarViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: UITabBarViewController())
            .makePreview()
    }
}
#endif
