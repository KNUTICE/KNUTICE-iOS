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
@objc protocol SettingButtonConfigurable: AnyObject {
    @objc func navigateToSetting(_ sender: UIButton)
}

extension SettingButtonConfigurable where Self: UIViewController {
    func setSettingBarButtonItem() {
        navigationItem.rightBarButtonItem = getSettingBarButtonItem()
    }

    func getSettingBarButtonItem() -> UIBarButtonItem {
        createBarButtonItem(
            imageSystemName: "gearshape",
            action: #selector(navigateToSetting(_:))
        )
    }

    private func createBarButtonItem(imageSystemName: String, action: Selector) -> UIBarButtonItem {
        UIBarButtonItem(
            image: UIImage(systemName: imageSystemName),
            style: .plain,
            target: self,
            action: action
        )
    }
}
