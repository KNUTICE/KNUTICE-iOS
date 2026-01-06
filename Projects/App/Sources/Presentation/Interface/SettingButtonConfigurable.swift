//
//  SettingButtonConfigurable.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/3/25.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
protocol SettingButtonConfigurable: AnyObject {
    func setSettingBarButtonItem()
}

extension SettingButtonConfigurable where Self: UIViewController {
    var settingBarButtonItem: UIBarButtonItem {
        UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            primaryAction: UIAction { [weak self] _ in
                let viewController = UIHostingController(rootView: SettingView())
                self?.navigationController?.pushViewController(viewController, animated: true)
        })
    }
    
    func setSettingBarButtonItem() {
        navigationItem.rightBarButtonItem = settingBarButtonItem
    }
    
}
