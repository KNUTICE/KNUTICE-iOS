//
//  SecondTabNavigationItemConfigurable.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/3/25.
//

import Foundation
import KNUTICECore
import UIKit

@MainActor
@objc protocol SecondTabNavigationItemConfigurable {
    @objc func didTapMajorSelectionButton(_ sender: UIButton)
}

extension SecondTabNavigationItemConfigurable where Self: UIViewController {
    func makeMajorSelectionButton(withTitle title: String? = nil) {
        let majorStr = UserDefaults.shared?.string(forKey: UserDefaultsKeys.selectedMajor.rawValue) ?? ""
        let selectedMajor = MajorCategory(rawValue: majorStr)
        var config = UIButton.Configuration.plain()
        config.title = title ?? selectedMajor?.localizedDescription ?? "학과 선택"
        config.image = UIImage(systemName: "chevron.right")
        config.imagePlacement = .trailing
        config.imagePadding = 3
        config.contentInsets = .zero
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            return outgoing
        }
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        
        let button = UIButton(type: .system)
        button.configuration = config
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(didTapMajorSelectionButton(_:)), for: .touchUpInside)
        
        let leftBarItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = leftBarItem
        
        if #available(iOS 26, *) {
            navigationItem.leftBarButtonItem?.hidesSharedBackground = true
        }
    }

}
