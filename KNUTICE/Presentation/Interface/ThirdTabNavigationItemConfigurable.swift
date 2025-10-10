//
//  ThirdTabNavigationItemConfigurable.swift
//  KNUTICE
//
//  Created by 이정훈 on 10/5/25.
//

import UIKit
import KNUTICECore

@MainActor
protocol ThirdTabNavigationItemConfigurable: AnyObject {
    var sortedBookmarkViewModel: BookmarkSortOptionProvidable { get }
}

extension ThirdTabNavigationItemConfigurable where Self: UIViewController {
    func makeBookmarkTitleBarItem() {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "북마크"
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        
        if #available(iOS 26, *) {
            navigationItem.leftBarButtonItem?.hidesSharedBackground = true
        }
    }
    
    func makeSortMenuButton(selectedOption: BookmarkSortOption) -> UIBarButtonItem {
        let configuration = UIImage.SymbolConfiguration(textStyle: .title2)
        let upAndDownImage = UIImage(systemName: "arrow.up.arrow.down.circle", withConfiguration: configuration)?
            .withRenderingMode(.alwaysTemplate)
        let selectedUpAndDownImage = UIImage(systemName: "arrow.up.arrow.down.circle", withConfiguration: configuration)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.lightGray)
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.showsMenuAsPrimaryAction = true
        button.setImage(upAndDownImage, for: .normal)
        button.setImage(selectedUpAndDownImage, for: .highlighted)
        button.menu = makeSortMenu(selectedOption: selectedOption)
        
        return UIBarButtonItem(customView: button)
    }
    
    private func makeSortMenu(selectedOption: BookmarkSortOption) -> UIMenu {
        func makeAction(title: String, option: BookmarkSortOption) -> UIAction {
            return UIAction(
                title: title,
                image: selectedOption == option ? UIImage(systemName: "checkmark") : nil,
                handler: { [weak self] _ in
                    UserDefaults.standard.set(option.rawValue, forKey: UserDefaultsKeys.bookmarkSortOption.rawValue)
                    self?.sortedBookmarkViewModel.bookmarkSortOption = option
                }
            )
        }
        
        let actions = [
            makeAction(title: "오래된 생성일", option: .createdAtAscending),
            makeAction(title: "최근 생성일", option: .createdAtDescending),
            makeAction(title: "오래된 수정일", option: .updatedAtAscending),
            makeAction(title: "최근 수정일", option: .updatedAtDescending)
        ]
        
        return UIMenu(
            title: "북마크 정렬",
            identifier: nil,
            options: .displayInline,
            children: actions
        )
    }
}
