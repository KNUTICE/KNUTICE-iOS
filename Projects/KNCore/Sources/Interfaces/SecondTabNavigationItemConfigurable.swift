//
//  SecondTabNavigationItemConfigurable.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/3/25.
//

import Foundation
import KNUtility
import UIKit

@MainActor
public protocol SecondTabNavigationItemConfigurable {}

public extension SecondTabNavigationItemConfigurable where Self: UIViewController {
    func setNoticeBarButtonItem() {
        let titleLabel = UILabel()
        titleLabel.text = "공지"
        titleLabel.font = UIFont.font(for: .title2, weight: .heavy)
        let labelItem = UIBarButtonItem(customView: titleLabel)
        
        navigationItem.leftBarButtonItem = labelItem
        
        if #available(iOS 26, *) {
            navigationItem.leftBarButtonItem?.hidesSharedBackground = true
        }
    }

}
