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
    func makeSettingBarButtonItem() {
        navigationItem.rightBarButtonItem = createSettingBarButtonItem()
    }

    func createSettingBarButtonItem() -> UIBarButtonItem {
        makeBarButtonItem(
            imageSystemName: "gearshape",
            action: #selector(navigateToSetting(_:))
        )
    }

    private func makeBarButtonItem(imageSystemName: String, action: Selector) -> UIBarButtonItem {
        UIBarButtonItem(
            image: UIImage(systemName: imageSystemName),
            style: .plain,
            target: self,
            action: action
        )
    }
}
