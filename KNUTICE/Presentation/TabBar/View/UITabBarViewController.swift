//
//  UITabBarViewController.swift
//  KNUTICE
//
//  Created by 이정훈 on 1/4/25.
//

import Combine
import KNUTICECore
import UIKit
import SwiftUI

final class UITabBarViewController: UITabBarController {
    private let mainViewController: UIViewController = {
        let viewController = MainTableViewController()
        viewController.tabBarItem.image = UIImage(systemName: "house")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        viewController.tabBarItem.title = "홈"
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UINavigationController(rootViewController: viewController)
        }
        
        return viewController
    }()
    private let majorNoticeViewController: UIViewController = {
        let majorStr = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedMajor.rawValue)
        let viewController = MajorNoticeCollectionViewController(
            viewModel: NoticeCollectionViewModel(category: MajorCategory(rawValue: majorStr ?? ""))
        )
        viewController.tabBarItem.image = UIImage(systemName: "graduationcap")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "graduationcap.fill")
        viewController.tabBarItem.title = "학과소식"
        
        return viewController
    }()
    private let bookmarkViewController: UIViewController = {
        let viewController = BookmarkTableViewController()
        viewController.tabBarItem.image = UIImage(systemName: "bookmark")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill")
        viewController.tabBarItem.title = "북마크"
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UINavigationController(rootViewController: viewController)
        }
        
        return viewController
    }()
    private let searchViewController: UIViewController = {
        let viewController = SearchViewController()
        
        if #available(iOS 26, *) {
            viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
            
            return viewController
        } else {
            viewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
            
            if UIDevice.current.userInterfaceIdiom  == .phone {
                viewController.tabBarItem.title = "검색"
            }
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                return UINavigationController(rootViewController: viewController)
            }
            
            return viewController
        }
    }()
    let viewModel: TabBarViewModel
    var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabBar()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension UITabBarViewController {
    func setUpTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        if #available(iOS 18, *), UIDevice.current.userInterfaceIdiom == .pad {
            tabs = [
                UITab(title: "홈", image: UIImage(systemName: "house.fill"), identifier: "Tabs.main") { _ in
                    self.mainViewController
                },
                UITab(title: "학과소식", image: UIImage(systemName: "graduationcap.fill"), identifier: "Tabs.majorNotice") { _ in
                    self.majorNoticeViewController
                },
                UITab(title: "북마크", image: UIImage(systemName: "bookmark.fill"), identifier: "Tabs.bookmark") { _ in
                    self.bookmarkViewController
                },
                UISearchTab { _ in
                    self.searchViewController
                }
            ]
        } else {
            setViewControllers([mainViewController, majorNoticeViewController, bookmarkViewController, searchViewController], animated: true)
        }
    }
    
}


#if DEBUG
struct UITabBarViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UINavigationController(rootViewController: UITabBarViewController(viewModel: TabBarViewModel()))
            .makePreview()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
