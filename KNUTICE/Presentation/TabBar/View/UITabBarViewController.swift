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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [mainViewController]
        setupTabBar()
        setupShadowView()
        setupNavigationBar()
    }
}

extension UITabBarViewController {
    private func setupTabBar() {
        mainViewController.tabBarItem.image = UIImage(systemName: "house")
        mainViewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        mainViewController.tabBarItem.title = "홈"
        
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

extension UITabBarViewController {
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "KNUTICE"
        titleLabel.font = UIFont.font(for: .title2, weight: .heavy)
        let labelItem = UIBarButtonItem(customView: titleLabel)
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -25
        
        navigationItem.leftBarButtonItems = [negativeSpacer, labelItem]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(navigateToSetting(_:))),
            UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(navigateToSearch(_:)))
        ]
    }
    
    //MARK: - Toolbar Button Callback Function
    @objc func navigateToSetting(_ sender: UIButton) {
        let viewController = UIHostingController(rootView: SettingView(viewModel: AppDI.shared.makeSettingViewModel()))
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func navigateToSearch(_ sender: UIButton) {
        let viewController = SearchTableViewController(viewModel: AppDI.shared.makeSearchTableViewModel())
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
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
