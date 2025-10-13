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

typealias NavigationItemConfigurable = FirstTabNavigationItemConfigurable & SecondTabNavigationItemConfigurable & SettingButtonConfigurable & ThirdTabNavigationItemConfigurable

final class UITabBarViewController: UITabBarController, NavigationItemConfigurable {
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
        viewController.tabBarItem.image = UIImage(systemName: "globe")
        viewController.tabBarItem.selectedImage = UIImage(systemName: "globe.fill")
        viewController.tabBarItem.title = "학과소식"
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UINavigationController(rootViewController: viewController)
        }
        
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
    var sortedBookmarkViewModel: BookmarkSortOptionProvidable {
        return viewModel
    }
    var cancellables: Set<AnyCancellable> = []
    
    init(viewModel: TabBarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setUpTabBar()
        bind()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            setFirstTabNavigationItems()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}

extension UITabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch viewController {
            case is MainTableViewController:
                setFirstTabNavigationItems()
            case is MajorNoticeCollectionViewController:
                setSecondTabNavigationItems()
            case is BookmarkTableViewController:
                setThirdTabNavigationItems(selectedOption: viewModel.bookmarkSortOption)
            default:
                removeAllNavigationItems()
            }
        }
    }
}

extension UITabBarViewController {
    @objc func navigateToSetting(_ sender: UIButton) {
        let viewController = UIHostingController(rootView: SettingView())
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func didTapMajorSelectionButton(_ sender: UIButton) {
        let viewController = UIHostingController(
            rootView: MajorSelectionView<TabBarViewModel>()
                .environmentObject(viewModel)
        )
        viewController.modalPresentationStyle = .pageSheet
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        present(viewController, animated: true)
    }
}

extension UITabBarViewController {
    func setFirstTabNavigationItems() {
        // Bookmark의 rightBarButtonItems 제거
        navigationItem.rightBarButtonItems = nil
        setTitleBarButtonItem()
        setSettingBarButtonItem()
    }
    
    func setSecondTabNavigationItems() {
        // Bookmark의 rightBarButtonItems 제거
        navigationItem.rightBarButtonItems = nil
        makeMajorSelectionButton()
        setSettingBarButtonItem()
    }
    
    func setThirdTabNavigationItems(selectedOption sortOption: BookmarkSortOption) {
        makeBookmarkTitleBarItem()
        navigationItem.rightBarButtonItems = [
            getSettingBarButtonItem(),
            makeSortMenuButton(selectedOption: sortOption)
        ]
    }
    
    func removeAllNavigationItems() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        navigationItem.rightBarButtonItems = nil
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
                UITab(title: "학과소식", image: UIImage(systemName: "globe.fill"), identifier: "Tabs.majorNotice") { _ in
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
        UINavigationController(rootViewController: UITabBarViewController(
            viewModel: TabBarViewModel(category: .computerScience))
        )
        .makePreview()
        .edgesIgnoringSafeArea(.all)
    }
}
#endif

