//
//  FirstTabNavigationItemConfigurable.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/3/25.
//

import Foundation
import UIKit
import SwiftUI

@MainActor
@objc protocol FirstTabNavigationItemConfigurable {}

extension FirstTabNavigationItemConfigurable where Self: UIViewController {
    func setTitleBarButtonItem() {
        let titleLabel = UILabel()
        titleLabel.text = "KNUTICE"
        titleLabel.font = UIFont.font(for: .title2, weight: .heavy)
        let labelItem = UIBarButtonItem(customView: titleLabel)
        
        navigationItem.leftBarButtonItem = labelItem
        
        if #available(iOS 26, *) {
            navigationItem.leftBarButtonItem?.hidesSharedBackground = true
        }
    }
    
}
