//
//  UITabBarViewController+Delegate.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/4/25.
//

import UIKit
import SwiftUI

extension UITabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateNavigationBar(for: selectedIndex)
    }
    
    func updateNavigationBar(for index: Int) {
        switch index {
        case 1:
            setupReminderNavigationBar()
        default:
            setupMainNavigationBar()
        }
    }
    
    private func setupMainNavigationBar() {
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
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .mainBackground
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupReminderNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "리마인더"
        titleLabel.font = UIFont.font(for: .title2, weight: .heavy)
        let labelItem = UIBarButtonItem(customView: titleLabel)
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -25
        
        navigationItem.leftBarButtonItems = [negativeSpacer, labelItem]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(navigateToSetting(_:)))
        ]
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .mainBackground
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
